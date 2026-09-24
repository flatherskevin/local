/**
 * Session header rows for the interactive composer.
 *
 * Mounts a `belowEditor` widget, which the composer renders between the prompt
 * editor and the built-in status bar, so the bottom chrome reads:
 *
 *   row 1  session name (full, word-wrapped, never elided)
 *   row 2  pull requests and issue-tracker tickets this session acted on
 *   row 3  the directory and branch work is landing in
 *   row 4  the built-in status bar (model, context, cost)
 *
 * Rows 2 and 3 are deliberately evidence-based rather than mention-based. A
 * link appears only once a tool call operated on it (a `gh pr` command, a
 * `pr://` read, an issue-tracker tool invocation) or the checked-out branch
 * resolves to a pull request; the directory comes from the `cwd` a shell
 * command ran in or the `path` an edit wrote to. Prose, prompts, and unrelated
 * tool output are never scanned, so discussing a ticket cannot fabricate a link.
 *
 * No issue tracker is hardcoded. `ISSUE_TRACKERS` below is a registry keyed by
 * name, and two environment variables — set in `~/.localrc`, since the tracker
 * changes with the machine — pick one:
 *
 *   OMP_ISSUE_TRACKER  registry key, e.g. `linear` or `jira`
 *   OMP_ISSUE_SITE     the workspace slug or host that tracker needs
 *
 * Unset, the ticket half of row 2 stays off and pull requests still work.
 * Supporting another tracker is one more entry in the registry.
 *
 * The built-in `path` and `git` segments report the session's own project
 * directory, which stays at the launch checkout even while the work happens in
 * a linked worktree. Row 3 replaces them, so drop both from
 * `statusLine.leftSegments`.
 *
 * Rows are handed over as plain strings, which the host wraps with
 * `wrapTextWithAnsi` instead of truncating, and carry OSC 8 hyperlinks so the
 * labels are clickable without spelling out full URLs.
 */
import { homedir } from "node:os";
import * as path from "node:path";
import type { ExtensionAPI, ExtensionContext } from "@oh-my-pi/pi-coding-agent";
import { fileHyperlink, isHyperlinkEnabled, urlHyperlink } from "@oh-my-pi/pi-tui/render";
import { theme } from "@oh-my-pi/pi-tui/theme";
import type { ThemeColor } from "@oh-my-pi/pi-tui/theme/schema";

const WIDGET_KEY = "session-header";
const UNTITLED_SESSION_LABEL = "untitled session";
const LINK_SEPARATOR = "  ";
/** Keeps an icon on the same wrapped row as the label it belongs to. */
const ICON_GLUE = "\u00a0";
const COLLAPSIBLE_WHITESPACE = /\s+/g;
const HOME_DIRECTORY = homedir();
const GIT_COMMAND_TIMEOUT_MS = 5_000;
const GITHUB_COMMAND_TIMEOUT_MS = 10_000;
const REPOSITORY_REFRESH_INTERVAL_MS = 15_000;
const MAX_SCAN_CHARACTERS = 512_000;

/** Tools whose action lives in a `command` argument, with `cwd` naming where it ran. */
const COMMAND_TOOLS: Record<string, true> = { bash: true, shell: true };
/** Tools whose action lives in a `path` argument naming the resource they operate on. */
const PATH_TOOLS: Record<string, true> = { read: true, write: true, fetch: true };
/** Tools that change files, so their `path` marks where work is landing. */
const WORK_PATH_TOOLS: Record<string, true> = { write: true, edit: true };

const PULL_REQUEST_COMMAND = /\bgh\b[^\n]{0,200}?\bpr\b/;
const PULL_REQUEST_API_PATH = /\/pulls(?:\/|\b)/;
const PULL_REQUEST_RESOURCE = /^pr:\/\/\d/;
/** Any scheme-qualified target, which is never a filesystem directory. */
const SCHEME_QUALIFIED = /^[a-z][a-z0-9+.-]*:\/\//i;
/** A `cd <dir> && …` prefix, which omp itself treats as the command's working directory. */
const LEADING_CHANGE_DIRECTORY = /^\s*cd\s+("[^"]+"|'[^']+'|[^\s&;|]+)\s*&&/;
const SURROUNDING_QUOTES = /^["']|["']$/g;
const REGEX_METACHARACTERS = /[.*+?^${}()|[\]\\]/g;
const ID_PLACEHOLDER = "{id}";

const PULL_REQUEST_URL = /https?:\/\/([^\s"'`<>/)\]]+)\/([^\s"'`<>/)\]]+)\/([^\s"'`<>/)\]]+)\/pull\/(\d+)/g;
/** An MCP device path, so a file merely named after a tracker is not mistaken for one. */
const MCP_DEVICE_RESOURCE = /^(?:xd:\/\/)?mcp__/;

/**
 * One issue tracker's shape. Adding a tracker means adding an entry to
 * {@link ISSUE_TRACKERS} — nothing downstream of this record knows any vendor.
 */
interface IssueTrackerProvider {
	/** What `OMP_ISSUE_SITE` means here, quoted back when it is missing. */
	siteHint: string;
	/** Identifier shape, as a regular-expression source string. */
	identifier: string;
	/** Matches this tracker's tool name and its MCP device path. */
	toolPattern: RegExp;
	/** Canonical issue URL for a site, with `{id}` standing in for the identifier. */
	urlTemplate(site: string): string;
}

const ISSUE_TRACKERS: Record<string, IssueTrackerProvider> = {
	linear: {
		siteHint: "workspace slug, as in https://linear.app/<slug>",
		identifier: "[A-Za-z][A-Za-z0-9]{1,9}-\\d{1,6}",
		toolPattern: /linear/i,
		urlTemplate: site => `https://linear.app/${site}/issue/${ID_PLACEHOLDER}`,
	},
	jira: {
		siteHint: "site host, as in acme.atlassian.net",
		identifier: "[A-Z][A-Z0-9]{1,9}-\\d{1,6}",
		toolPattern: /jira|atlassian/i,
		urlTemplate: site => `https://${site}/browse/${ID_PLACEHOLDER}`,
	},
};

/** A selected provider, compiled against the site this machine points at. */
interface IssueTracker {
	/** Recognizes a ticket URL already present in a command; group 1 is the identifier. */
	urlPattern: RegExp;
	/** Recognizes an identifier passed as a structured argument; group 1 is the identifier. */
	fieldPattern: RegExp;
	toolPattern: RegExp;
	buildUrl(identifier: string): string;
}

type TrackerReporter = (message: string, context: Record<string, unknown>) => void;

/**
 * Selected by `OMP_ISSUE_TRACKER` and `OMP_ISSUE_SITE`, which belong in
 * `~/.localrc` because the tracker changes with the machine. Returning
 * undefined simply leaves tickets out of row 2; pull requests are unaffected.
 */
function resolveIssueTracker(report: TrackerReporter): IssueTracker | undefined {
	const name = process.env.OMP_ISSUE_TRACKER?.trim().toLowerCase();
	if (!name) return undefined;
	const provider = ISSUE_TRACKERS[name];
	if (!provider) {
		report("session-header: unknown OMP_ISSUE_TRACKER", { name, known: Object.keys(ISSUE_TRACKERS).join(", ") });
		return undefined;
	}
	const site = process.env.OMP_ISSUE_SITE?.trim();
	if (!site) {
		report("session-header: OMP_ISSUE_SITE is required", { tracker: name, expected: provider.siteHint });
		return undefined;
	}
	const template = provider.urlTemplate(site);
	const placeholder = ID_PLACEHOLDER.replace(REGEX_METACHARACTERS, "\\$&");
	const literal = template.replace(REGEX_METACHARACTERS, "\\$&");
	try {
		return {
			urlPattern: new RegExp(literal.split(placeholder).join(`(${provider.identifier})`), "g"),
			fieldPattern: new RegExp(
				`"(?:id|key|identifier|issue|issueId|issueKey|issueIdOrKey)"\\s*:\\s*"(${provider.identifier})"`,
				"g",
			),
			toolPattern: provider.toolPattern,
			buildUrl: value => template.split(ID_PLACEHOLDER).join(value),
		};
	} catch (error) {
		report("session-header: tracker pattern did not compile", { tracker: name, error: String(error) });
		return undefined;
	}
}

type LinkKind = "pullRequest" | "ticket";

interface SessionLink {
	kind: LinkKind;
	label: string;
	url: string;
	sortKey: string;
}

/** Where work is landing: the checkout root, its branch, and whether it is a linked worktree. */
interface RepositoryLocation {
	root: string;
	branch: string;
	isWorktree: boolean;
}

interface RepositoryProbe {
	location: RepositoryLocation | undefined;
	probedAtMs: number;
}

interface LinkStyle {
	color: ThemeColor;
	icon: () => string;
}

const LINK_STYLES: Record<LinkKind, LinkStyle> = {
	pullRequest: { color: "statusLineGitClean", icon: () => theme.icon.pr },
	ticket: { color: "accent", icon: () => theme.icon.goal },
};

/** Session managers notify on auto-title generation, but the callback is absent from the readonly view. */
interface SessionNameNotifier {
	onSessionNameChanged(listener: () => void): () => void;
}

/** Serializes one source up to the character cap so a huge tool payload cannot stall a repaint. */
function stringifyForScan(source: unknown): string {
	if (typeof source === "string") return source.slice(0, MAX_SCAN_CHARACTERS);
	const seen = new WeakSet<object>();
	const serialized = JSON.stringify(source, (_key, value) => {
		if (typeof value !== "object" || value === null) return value;
		if (seen.has(value)) return undefined;
		seen.add(value);
		return value;
	});
	return serialized ? serialized.slice(0, MAX_SCAN_CHARACTERS) : "";
}

/** Reads one string argument, so evidence comes from the field a tool acts on rather than its whole payload. */
function readArgument(args: unknown, field: string): string {
	if (!args || typeof args !== "object") return "";
	const value = (args as Record<string, unknown>)[field];
	return typeof value === "string" ? value.slice(0, MAX_SCAN_CHARACTERS) : "";
}

function rememberLink(links: Map<string, SessionLink>, link: SessionLink): boolean {
	const key = link.kind === "ticket" ? `ticket:${link.label}` : `pullRequest:${link.url}`;
	if (links.has(key)) return false;
	links.set(key, link);
	return true;
}

/** Tickets collapse on identifier so an argument field and a ticket URL stay one entry. */
function rememberTicket(links: Map<string, SessionLink>, tracker: IssueTracker, identifier: string): boolean {
	const ticket = identifier.toUpperCase();
	return rememberLink(links, {
		kind: "ticket",
		label: ticket,
		url: tracker.buildUrl(ticket),
		sortKey: `1:${ticket}`,
	});
}

function harvestPullRequestUrls(text: string, links: Map<string, SessionLink>): boolean {
	let added = false;
	for (const [, host, owner, repository, number] of text.matchAll(PULL_REQUEST_URL)) {
		const remembered = rememberLink(links, {
			kind: "pullRequest",
			label: `${repository}#${number}`,
			url: `https://${host}/${owner}/${repository}/pull/${number}`,
			sortKey: `0:${repository}:${number!.padStart(8, "0")}`,
		});
		added = remembered || added;
	}
	return added;
}

function harvestTickets(
	text: string,
	links: Map<string, SessionLink>,
	tracker: IssueTracker | undefined,
	includeFields: boolean,
): boolean {
	if (!tracker) return false;
	let added = false;
	for (const match of text.matchAll(tracker.urlPattern)) {
		added = rememberTicket(links, tracker, match[1]!) || added;
	}
	if (!includeFields) return added;
	for (const match of text.matchAll(tracker.fieldPattern)) {
		added = rememberTicket(links, tracker, match[1]!) || added;
	}
	return added;
}

function renderSessionRow(ctx: ExtensionContext): string {
	const name = ctx.sessionManager.getSessionName()?.replace(COLLAPSIBLE_WHITESPACE, " ").trim();
	const label = name ? theme.fg("accent", name) : theme.fg("muted", UNTITLED_SESSION_LABEL);
	return `${theme.fg("muted", theme.icon.session)}${ICON_GLUE}${label}`;
}

function renderLink(link: SessionLink): string {
	const style = LINK_STYLES[link.kind];
	const label = theme.fg(style.color, `${style.icon()}${ICON_GLUE}${link.label}`);
	return isHyperlinkEnabled() ? urlHyperlink(link.url, label) : `${label} ${theme.fg("muted", link.url)}`;
}

function renderLinkRow(links: Map<string, SessionLink>): string | undefined {
	if (links.size === 0) return undefined;
	return Array.from(links.values())
		.sort((left, right) => left.sortKey.localeCompare(right.sortKey))
		.map(renderLink)
		.join(LINK_SEPARATOR);
}

function renderLocationRow(location: RepositoryLocation): string {
	const displayRoot = location.root.startsWith(HOME_DIRECTORY)
		? `~${location.root.slice(HOME_DIRECTORY.length)}`
		: location.root;
	const icon = location.isWorktree ? theme.icon.worktree : theme.icon.folder;
	const directory = theme.fg("statusLinePath", `${icon}${ICON_GLUE}${displayRoot}`);
	const branch = theme.fg("statusLineGitClean", `${theme.icon.branch}${ICON_GLUE}${location.branch}`);
	const linked = isHyperlinkEnabled() ? fileHyperlink(location.root, directory) : directory;
	return `${linked}${LINK_SEPARATOR}${branch}`;
}

function buildRows(
	ctx: ExtensionContext,
	links: Map<string, SessionLink>,
	location: RepositoryLocation | undefined,
): string[] {
	const rows = [renderSessionRow(ctx)];
	const linkRow = renderLinkRow(links);
	if (linkRow) rows.push(linkRow);
	if (location) rows.push(renderLocationRow(location));
	return rows;
}

export default function sessionHeader(pi: ExtensionAPI): void {
	const tracker = resolveIssueTracker((message, context) => pi.logger.warn(message, context));
	const links = new Map<string, SessionLink>();
	const pullRequestActionIds = new Set<string>();
	const scannedEntryIds = new Set<string>();
	const inspectedBranches = new Set<string>();
	const probesByDirectory = new Map<string, RepositoryProbe>();
	let workDirectory: string | undefined;
	let location: RepositoryLocation | undefined;
	let paintedRows = "";
	let repositoryProbeInFlight = false;
	let releaseSessionNameListener: (() => void) | undefined;

	/** A pull-request action's own output carries the URL (`gh pr create`), so its result is worth scanning. */
	const ingestToolCall = (toolCallId: string, toolName: string, args: unknown): boolean => {
		const command = COMMAND_TOOLS[toolName] ? readArgument(args, "command") : "";
		const resource = PATH_TOOLS[toolName] ? readArgument(args, "path") : "";
		let added = false;

		const changeDirectory = LEADING_CHANGE_DIRECTORY.exec(command)?.[1]?.replace(SURROUNDING_QUOTES, "") ?? "";
		const shellDirectory = COMMAND_TOOLS[toolName] ? readArgument(args, "cwd") || changeDirectory : "";
		const editedPath = WORK_PATH_TOOLS[toolName] ? readArgument(args, "path") : "";
		const workTarget = shellDirectory || (editedPath && path.dirname(editedPath));
		if (workTarget && !SCHEME_QUALIFIED.test(workTarget) && path.isAbsolute(workTarget)) {
			workDirectory = workTarget;
		}

		const opensPullRequest =
			PULL_REQUEST_RESOURCE.test(resource) ||
			(command !== "" && (PULL_REQUEST_COMMAND.test(command) || PULL_REQUEST_API_PATH.test(command)));
		if (opensPullRequest) {
			pullRequestActionIds.add(toolCallId);
			added = harvestPullRequestUrls(command, links) || added;
			added = harvestTickets(command, links, tracker, false) || added;
		}

		if (tracker?.toolPattern.test(toolName)) {
			added = harvestTickets(stringifyForScan(args), links, tracker, true) || added;
		} else if (tracker && MCP_DEVICE_RESOURCE.test(resource) && tracker.toolPattern.test(resource)) {
			added = harvestTickets(readArgument(args, "content"), links, tracker, true) || added;
		}
		return added;
	};

	const ingestToolResult = (toolCallId: string, content: unknown): boolean => {
		if (!pullRequestActionIds.has(toolCallId)) return false;
		const resultText = stringifyForScan(content);
		return resultText ? harvestPullRequestUrls(resultText, links) : false;
	};

	const ingestMessage = (message: unknown): boolean => {
		const record = message as { role?: string; content?: unknown; toolCallId?: string };
		if (record.role === "toolResult") {
			return typeof record.toolCallId === "string" ? ingestToolResult(record.toolCallId, record.content) : false;
		}
		if (!Array.isArray(record.content)) return false;
		let added = false;
		for (const blockValue of record.content) {
			const block = blockValue as { type?: string; id?: string; name?: string; arguments?: unknown };
			if (block?.type !== "toolCall" || typeof block.id !== "string" || typeof block.name !== "string") continue;
			added = ingestToolCall(block.id, block.name, block.arguments) || added;
		}
		return added;
	};

	/** One `rev-parse` yields the checkout root, its git dir, the shared common dir, and the branch. */
	const probeRepository = async (directory: string): Promise<RepositoryLocation | undefined> => {
		try {
			const result = await pi.exec(
				"git",
				["rev-parse", "--path-format=absolute", "--show-toplevel", "--git-dir", "--git-common-dir", "--abbrev-ref", "HEAD"],
				{ cwd: directory, timeout: GIT_COMMAND_TIMEOUT_MS },
			);
			if (result.code !== 0) return undefined;
			const [root, gitDir, commonDir, branch] = result.stdout.trim().split("\n");
			if (!root || !gitDir || !commonDir || !branch || branch === "HEAD") return undefined;
			return { root, branch, isWorktree: gitDir !== commonDir };
		} catch (error) {
			pi.logger.debug("session-header: repository probe failed", { directory, error: String(error) });
			return undefined;
		}
	};

	const readBranchPullRequestUrl = async (cwd: string): Promise<string | undefined> => {
		try {
			const result = await pi.exec("gh", ["pr", "view", "--json", "url"], {
				cwd,
				timeout: GITHUB_COMMAND_TIMEOUT_MS,
			});
			if (result.code !== 0) return undefined;
			const url: unknown = JSON.parse(result.stdout).url;
			return typeof url === "string" ? url : undefined;
		} catch (error) {
			pi.logger.debug("session-header: pull request lookup failed", { cwd, error: String(error) });
			return undefined;
		}
	};

	const paint = (ctx: ExtensionContext): void => {
		if (!ctx.hasUI || ctx.mode !== "tui") return;
		const rows = buildRows(ctx, links, location);
		const fingerprint = rows.join("\n");
		if (fingerprint === paintedRows) return;
		paintedRows = fingerprint;
		ctx.ui.setWidget(WIDGET_KEY, rows, { placement: "belowEditor" });
	};

	const scanSessionHistory = (ctx: ExtensionContext): boolean => {
		let added = false;
		for (const entry of ctx.sessionManager.getBranch()) {
			if (scannedEntryIds.has(entry.id)) continue;
			scannedEntryIds.add(entry.id);
			const message = (entry as { type?: string; message?: unknown }).message;
			if (message) added = ingestMessage(message) || added;
		}
		return added;
	};

	/**
	 * Resolve where work is landing, then look up that branch's pull request
	 * once. Probes are memoized per directory and refreshed on an interval so a
	 * checkout in the same directory is picked up without re-running git on
	 * every turn.
	 */
	const syncRepository = async (ctx: ExtensionContext): Promise<void> => {
		if (repositoryProbeInFlight) return;
		const directory = workDirectory ?? ctx.cwd;
		const startedAtMs = Date.now();
		const probed = probesByDirectory.get(directory);
		if (probed && startedAtMs - probed.probedAtMs < REPOSITORY_REFRESH_INTERVAL_MS) {
			if (probed.location !== location) {
				location = probed.location;
				paint(ctx);
			}
			return;
		}
		repositoryProbeInFlight = true;
		try {
			const probedLocation = await probeRepository(directory);
			probesByDirectory.set(directory, { location: probedLocation, probedAtMs: startedAtMs });
			if (!probedLocation) return;
			if (probedLocation.root !== location?.root || probedLocation.branch !== location.branch) {
				location = probedLocation;
				paint(ctx);
			}
			const fingerprint = `${probedLocation.root}\u0000${probedLocation.branch}`;
			if (inspectedBranches.has(fingerprint)) return;
			inspectedBranches.add(fingerprint);
			const url = await readBranchPullRequestUrl(probedLocation.root);
			if (url && harvestPullRequestUrls(url, links)) paint(ctx);
		} finally {
			repositoryProbeInFlight = false;
		}
	};

	const refresh = (ctx: ExtensionContext): void => {
		scanSessionHistory(ctx);
		paint(ctx);
		void syncRepository(ctx);
	};

	const listenForSessionName = (ctx: ExtensionContext): void => {
		releaseSessionNameListener?.();
		releaseSessionNameListener = undefined;
		const manager = ctx.sessionManager as Partial<SessionNameNotifier>;
		if (typeof manager.onSessionNameChanged !== "function") return;
		try {
			releaseSessionNameListener = manager.onSessionNameChanged(() => paint(ctx));
		} catch (error) {
			pi.logger.debug("session-header: session name subscription failed", { error: String(error) });
		}
	};

	const mount = (ctx: ExtensionContext): void => {
		links.clear();
		pullRequestActionIds.clear();
		scannedEntryIds.clear();
		inspectedBranches.clear();
		probesByDirectory.clear();
		workDirectory = undefined;
		location = undefined;
		paintedRows = "";
		listenForSessionName(ctx);
		refresh(ctx);
	};

	pi.on("session_start", (_event, ctx) => mount(ctx));
	pi.on("session_switch", (_event, ctx) => mount(ctx));
	pi.on("session_branch", (_event, ctx) => mount(ctx));
	pi.on("turn_end", (_event, ctx) => refresh(ctx));
	pi.on("message_end", (event, ctx) => {
		if (ingestMessage(event.message)) paint(ctx);
		void syncRepository(ctx);
	});
	pi.on("session_shutdown", () => {
		releaseSessionNameListener?.();
		releaseSessionNameListener = undefined;
	});
}
