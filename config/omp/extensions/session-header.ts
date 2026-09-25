/**
 * Session header rows for the interactive composer.
 *
 * Mounts a `belowEditor` widget, which the composer renders between the prompt
 * editor and the built-in status bar, so the bottom chrome reads:
 *
 *   row 1  session name (full, word-wrapped, never elided)
 *   row 2  pull requests and tickets, glyphed by what this session did to each
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
 * That same evidence assigns a role, which picks the glyph: `active` is the
 * branch's own pull request and any ticket the branch is named after,
 * `editing` is a call that changed the thing, `reviewing` is a diff or review,
 * and `reference` is a plain read, shown muted. A link only ever moves up that
 * list, so looking something up later cannot demote work already done.
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
import { getSessionAccentAnsi, theme } from "@oh-my-pi/pi-tui/theme";
import type { ThemeColor } from "@oh-my-pi/pi-tui/theme/schema";
import type { SymbolPreset } from "@oh-my-pi/pi-tui/theme/symbols";

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
/** Pull-request state costs a `gh` call each, so it refreshes slower and only for work in hand. */
const PULL_REQUEST_STATE_INTERVAL_MS = 60_000;
const MAX_PULL_REQUEST_STATE_LOOKUPS = 3;
const MAX_SCAN_CHARACTERS = 512_000;

/** Tools whose action lives in a `command` argument, with `cwd` naming where it ran. */
const COMMAND_TOOLS: Record<string, true> = { bash: true, shell: true };
/** Tools whose action lives in a `path` argument naming the resource they operate on. */
const PATH_TOOLS: Record<string, true> = { read: true, write: true, fetch: true };
/** Tools that change files, so their `path` marks where work is landing. */
const WORK_PATH_TOOLS: Record<string, true> = { write: true, edit: true };

const PULL_REQUEST_COMMAND = /\bgh\b[^\n]{0,200}?\bpr\b/;
/** The `gh pr <subcommand>` verb, which says what this session is doing with the pull request. */
const PULL_REQUEST_SUBCOMMAND = /\bgh\b[^\n]{0,200}?\bpr\s+([a-z-]+)/;
const PULL_REQUEST_API_PATH = /\/pulls(?:\/|\b)/;
const PULL_REQUEST_RESOURCE = /^pr:\/\/\d/;
/** A `pr://<n>/diff` read is reviewing; a bare `pr://<n>` read is only looking. */
const PULL_REQUEST_DIFF_RESOURCE = /^pr:\/\/\d+\/diff/;
/** Tracker tool verbs that change a ticket rather than read one. */
const TRACKER_MUTATION = /create|save|update|edit|add|set|move|transition|assign|comment/i;

const PULL_REQUEST_ROLES: Record<string, LinkRole> = {
	create: "editing",
	edit: "editing",
	merge: "editing",
	ready: "editing",
	reopen: "editing",
	close: "editing",
	checkout: "editing",
	review: "reviewing",
	comment: "reviewing",
	diff: "reviewing",
	checks: "reviewing",
};

/**
 * A tracker's workflow state, read out of whatever payload its tool returned.
 * Both a nested `{"state":{"name":"In Review"}}` and a flat `{"status":"Done"}`
 * are matched, which covers every tracker shape seen so far without asking a
 * provider to describe its own JSON.
 */
const ISSUE_STATE_FIELD = /"(?:state|status)"\s*:\s*(?:\{[^{}]*?"name"\s*:\s*"([^"]+)"|"([^"]+)")/;
const ISSUE_STATE_DONE = /\b(?:done|complete|completed|closed|resolved|shipped|merged)\b/i;
const ISSUE_STATE_IN_REVIEW = /review/i;
/** GitHub check states that mean the run has not settled yet. */
const CHECK_IN_FLIGHT = /"(?:status|state)"\s*:\s*"(?:QUEUED|IN_PROGRESS|PENDING|WAITING|REQUESTED)"/;
/** JSON carried inside a text block arrives escaped; scanning collapses it first. */
const ESCAPED_QUOTE = /\\"/g;
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

/**
 * What this session is doing with a link. A link only ever moves up this list,
 * so one reference read cannot demote something already being edited.
 */
type LinkRole = "active" | "editing" | "reviewing" | "reference";

const ROLE_RANK: Record<LinkRole, number> = { active: 0, editing: 1, reviewing: 2, reference: 3 };

/**
 * What the thing itself is doing, as opposed to what this session did to it.
 * A known state outranks the role for display, because a merged pull request
 * is merged no matter who touched it.
 */
type LinkState = "building" | "merged" | "inReview" | "done";

interface SessionLink {
	kind: LinkKind;
	role: LinkRole;
	state: LinkState | undefined;
	label: string;
	url: string;
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
	paint: (text: string) => string;
	icon: () => string;
}

function themePaint(color: ThemeColor): (text: string) => string {
	return text => theme.fg(color, text);
}

/**
 * Merged is purple everywhere git forges are drawn, and no theme here carries a
 * purple token, so this one colour is literal. It still goes through the
 * theme's own converter, which drops to 256-colour when truecolor is absent.
 */
function hexPaint(hex: string): (text: string) => string {
	return text => {
		const ansi = getSessionAccentAnsi(hex);
		return ansi ? `${ansi}${text}\x1b[0m` : text;
	};
}

const MERGED_PURPLE = "#a371f7";

/** One glyph per relationship, so the row reads at a glance instead of by label. */
const LINK_STYLES: Record<LinkKind, Record<LinkRole, LinkStyle>> = {
	pullRequest: {
		active: { paint: themePaint("statusLineGitClean"), icon: () => theme.icon.pin },
		editing: { paint: themePaint("statusLineGitClean"), icon: () => theme.icon.pr },
		reviewing: { paint: themePaint("statusLineContext"), icon: () => theme.icon.advisor },
		reference: { paint: themePaint("muted"), icon: () => theme.icon.file },
	},
	ticket: {
		active: { paint: themePaint("accent"), icon: () => theme.icon.goal },
		editing: { paint: themePaint("accent"), icon: () => theme.icon.plan },
		reviewing: { paint: themePaint("statusLineContext"), icon: () => theme.icon.advisor },
		reference: { paint: themePaint("muted"), icon: () => theme.icon.file },
	},
};

/**
 * Landing and building deserve glyphs that carry across a glance, which the
 * theme's symbol sets do not offer, so these two supply their own per preset.
 * `nerd` gets the real Codicon; the others get the closest thing they can draw.
 */
function presetGlyph(glyphs: Record<SymbolPreset, string>): () => string {
	return () => glyphs[theme.getSymbolPreset()];
}

/** A settled or running state says more than the role, so it takes the glyph. */
const STATE_STYLES: Record<LinkState, LinkStyle> = {
	building: {
		paint: themePaint("warning"),
		icon: presetGlyph({ nerd: "\u{1F3D7}\uFE0F", unicode: "\u{1F3D7}\uFE0F", ascii: "[build]" }),
	},
	merged: {
		paint: hexPaint(MERGED_PURPLE),
		icon: presetGlyph({ nerd: "\ueafe", unicode: "\u{1F500}", ascii: "[merged]" }),
	},
	inReview: { paint: themePaint("statusLineContext"), icon: () => theme.icon.advisor },
	done: {
		paint: themePaint("success"),
		icon: presetGlyph({ nerd: "\u2705", unicode: "\u2705", ascii: "[ok]" }),
	},
};

/** Maps a tracker's own workflow-state wording onto the two states worth a glyph. */
function classifyIssueState(name: string): LinkState | undefined {
	if (ISSUE_STATE_DONE.test(name)) return "done";
	if (ISSUE_STATE_IN_REVIEW.test(name)) return "inReview";
	return undefined;
}

/** Session managers notify on auto-title generation, but the callback is absent from the readonly view. */
interface SessionNameNotifier {
	onSessionNameChanged(listener: () => void): () => void;
}

/**
 * Serializes one source for pattern matching, capped so a huge tool payload
 * cannot stall a repaint. Escaped quotes are collapsed because a tool result is
 * normally JSON carried inside a text block, which would otherwise arrive as
 * `\"state\"` and match nothing. The output is only ever scanned, never shown.
 */
function stringifyForScan(source: unknown): string {
	let text: string;
	if (typeof source === "string") {
		text = source;
	} else {
		const seen = new WeakSet<object>();
		text =
			JSON.stringify(source, (_key, value) => {
				if (typeof value !== "object" || value === null) return value;
				if (seen.has(value)) return undefined;
				seen.add(value);
				return value;
			}) ?? "";
	}
	return text.slice(0, MAX_SCAN_CHARACTERS).replace(ESCAPED_QUOTE, '"');
}

/** Reads one string argument, so evidence comes from the field a tool acts on rather than its whole payload. */
function readArgument(args: unknown, field: string): string {
	if (!args || typeof args !== "object") return "";
	const value = (args as Record<string, unknown>)[field];
	return typeof value === "string" ? value.slice(0, MAX_SCAN_CHARACTERS) : "";
}

/** Adds a link, or promotes one already present when fresh evidence outranks its role. */
function rememberLink(links: Map<string, SessionLink>, link: SessionLink): boolean {
	const key = link.kind === "ticket" ? `ticket:${link.label}` : `pullRequest:${link.url}`;
	const existing = links.get(key);
	if (!existing) {
		links.set(key, link);
		return true;
	}
	if (ROLE_RANK[link.role] >= ROLE_RANK[existing.role]) return false;
	existing.role = link.role;
	return true;
}

/** Tickets collapse on identifier so an argument field and a ticket URL stay one entry. */
function rememberTicket(
	links: Map<string, SessionLink>,
	tracker: IssueTracker,
	identifier: string,
	role: LinkRole,
): boolean {
	const ticket = identifier.toUpperCase();
	return rememberLink(links, {
		kind: "ticket",
		role,
		state: undefined,
		label: ticket,
		url: tracker.buildUrl(ticket),
	});
}

function harvestPullRequestUrls(text: string, links: Map<string, SessionLink>, role: LinkRole): boolean {
	let added = false;
	for (const [, host, owner, repository, number] of text.matchAll(PULL_REQUEST_URL)) {
		const remembered = rememberLink(links, {
			kind: "pullRequest",
			role,
			state: undefined,
			label: `${repository}#${number}`,
			url: `https://${host}/${owner}/${repository}/pull/${number}`,
		});
		added = remembered || added;
	}
	return added;
}

/** Returns the identifiers seen, so a caller can attach the state its result reports. */
function collectTicketIdentifiers(text: string, tracker: IssueTracker, includeFields: boolean): string[] {
	const found: string[] = [];
	for (const match of text.matchAll(tracker.urlPattern)) found.push(match[1]!.toUpperCase());
	if (includeFields) {
		for (const match of text.matchAll(tracker.fieldPattern)) found.push(match[1]!.toUpperCase());
	}
	return found;
}

function harvestTickets(
	text: string,
	links: Map<string, SessionLink>,
	tracker: IssueTracker | undefined,
	includeFields: boolean,
	role: LinkRole,
): string[] {
	if (!tracker) return [];
	const identifiers = collectTicketIdentifiers(text, tracker, includeFields);
	for (const identifier of identifiers) rememberTicket(links, tracker, identifier, role);
	return identifiers;
}

function renderSessionRow(ctx: ExtensionContext): string {
	const name = ctx.sessionManager.getSessionName()?.replace(COLLAPSIBLE_WHITESPACE, " ").trim();
	const label = name ? theme.fg("accent", name) : theme.fg("muted", UNTITLED_SESSION_LABEL);
	return `${theme.fg("muted", theme.icon.session)}${ICON_GLUE}${label}`;
}

function renderLink(link: SessionLink): string {
	const style = link.state ? STATE_STYLES[link.state] : LINK_STYLES[link.kind][link.role];
	const label = style.paint(`${style.icon()}${ICON_GLUE}${link.label}`);
	return isHyperlinkEnabled() ? urlHyperlink(link.url, label) : `${label} ${theme.fg("muted", link.url)}`;
}

const KIND_RANK: Record<LinkKind, number> = { pullRequest: 0, ticket: 1 };

/** Pull requests first, then tickets, and within each the most involved work leads. */
function compareLinks(left: SessionLink, right: SessionLink): number {
	return (
		KIND_RANK[left.kind] - KIND_RANK[right.kind] ||
		ROLE_RANK[left.role] - ROLE_RANK[right.role] ||
		left.label.localeCompare(right.label)
	);
}

function renderLinkRow(links: Map<string, SessionLink>): string | undefined {
	if (links.size === 0) return undefined;
	return Array.from(links.values()).sort(compareLinks).map(renderLink).join(LINK_SEPARATOR);
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
	const pullRequestActionRoles = new Map<string, LinkRole>();
	const trackerActionTickets = new Map<string, string[]>();
	const pullRequestStateCheckedAtMs = new Map<string, number>();
	const scannedEntryIds = new Set<string>();
	const inspectedBranches = new Set<string>();
	const probesByDirectory = new Map<string, RepositoryProbe>();
	let workDirectory: string | undefined;
	let location: RepositoryLocation | undefined;
	let paintedRows = "";
	let repositoryProbeInFlight = false;
	let releaseSessionNameListener: (() => void) | undefined;

	/** A tracker reports the truth about its own ticket, so its state replaces whatever was shown. */
	const applyTicketState = (identifiers: readonly string[], state: LinkState): boolean => {
		let changed = false;
		for (const identifier of identifiers) {
			const link = links.get(`ticket:${identifier}`);
			if (!link || link.state === state) continue;
			link.state = state;
			changed = true;
		}
		return changed;
	};

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
			const subcommand = PULL_REQUEST_SUBCOMMAND.exec(command)?.[1] ?? "";
			const role: LinkRole = PULL_REQUEST_DIFF_RESOURCE.test(resource)
				? "reviewing"
				: (PULL_REQUEST_ROLES[subcommand] ?? "reference");
			pullRequestActionRoles.set(toolCallId, role);
			added = harvestPullRequestUrls(command, links, role) || added;
			added = harvestTickets(command, links, tracker, false, role).length > 0 || added;
		}

		const ticketRole: LinkRole = TRACKER_MUTATION.test(toolName) ? "editing" : "reference";
		if (tracker?.toolPattern.test(toolName)) {
			const seen = harvestTickets(stringifyForScan(args), links, tracker, true, ticketRole);
			if (seen.length > 0) trackerActionTickets.set(toolCallId, seen);
			added = seen.length > 0 || added;
		} else if (tracker && MCP_DEVICE_RESOURCE.test(resource) && tracker.toolPattern.test(resource)) {
			const deviceRole: LinkRole = TRACKER_MUTATION.test(resource) ? "editing" : "reference";
			const seen = harvestTickets(readArgument(args, "content"), links, tracker, true, deviceRole);
			if (seen.length > 0) trackerActionTickets.set(toolCallId, seen);
			added = seen.length > 0 || added;
		}
		return added;
	};

	/** A tracker result carries the ticket's own workflow state; a pull-request result carries new URLs. */
	const ingestToolResult = (toolCallId: string, content: unknown): boolean => {
		const tickets = trackerActionTickets.get(toolCallId);
		if (tickets) {
			const stateName = ISSUE_STATE_FIELD.exec(stringifyForScan(content));
			const state = stateName ? classifyIssueState(stateName[1] ?? stateName[2] ?? "") : undefined;
			if (state) return applyTicketState(tickets, state);
			return false;
		}
		const role = pullRequestActionRoles.get(toolCallId);
		if (!role) return false;
		const resultText = stringifyForScan(content);
		return resultText ? harvestPullRequestUrls(resultText, links, role) : false;
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

	/**
	 * Ask GitHub what a pull request is doing. Only the work in hand is worth a
	 * subprocess, so this covers the links the session is active on or editing,
	 * capped per pass and re-checked on a slow interval.
	 */
	const refreshPullRequestStates = async (cwd: string): Promise<boolean> => {
		const now = Date.now();
		const candidates = Array.from(links.values())
			.filter(link => link.kind === "pullRequest" && link.state !== "merged")
			.filter(link => link.role === "active" || link.role === "editing")
			.filter(link => now - (pullRequestStateCheckedAtMs.get(link.url) ?? 0) >= PULL_REQUEST_STATE_INTERVAL_MS)
			.slice(0, MAX_PULL_REQUEST_STATE_LOOKUPS);
		let changed = false;
		for (const link of candidates) {
			pullRequestStateCheckedAtMs.set(link.url, now);
			try {
				const result = await pi.exec("gh", ["pr", "view", link.url, "--json", "state,statusCheckRollup"], {
					cwd,
					timeout: GITHUB_COMMAND_TIMEOUT_MS,
				});
				if (result.code !== 0) continue;
				const merged = /"state"\s*:\s*"MERGED"/.test(result.stdout);
				const state: LinkState | undefined = merged
					? "merged"
					: CHECK_IN_FLIGHT.test(result.stdout)
						? "building"
						: undefined;
				if (link.state === state) continue;
				link.state = state;
				changed = true;
			} catch (error) {
				pi.logger.debug("session-header: pull request state lookup failed", { url: link.url, error: String(error) });
			}
		}
		return changed;
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

	/** A branch named after a ticket is the strongest signal that it is the one being worked. */
	const promoteBranchTickets = (branch: string): boolean => {
		const haystack = branch.toUpperCase();
		let promoted = false;
		for (const link of links.values()) {
			if (link.kind !== "ticket" || link.role === "active") continue;
			if (!haystack.includes(link.label)) continue;
			link.role = "active";
			promoted = true;
		}
		return promoted;
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
			if (promoteBranchTickets(probedLocation.branch)) paint(ctx);
			const fingerprint = `${probedLocation.root}\u0000${probedLocation.branch}`;
			if (!inspectedBranches.has(fingerprint)) {
				inspectedBranches.add(fingerprint);
				const url = await readBranchPullRequestUrl(probedLocation.root);
				if (url && harvestPullRequestUrls(url, links, "active")) paint(ctx);
			}
			if (await refreshPullRequestStates(probedLocation.root)) paint(ctx);
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
		pullRequestActionRoles.clear();
		trackerActionTickets.clear();
		pullRequestStateCheckedAtMs.clear();
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
