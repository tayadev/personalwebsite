import { renderToStaticMarkup } from "react-dom/server";
import fs from "fs";
import { join, dirname } from "path";

const ROOT = "./home";
const DIST = "./dist";

function assetBase(relPath: string): string {
    const depth = relPath.split("/").length - 1;
    return depth === 0 ? "." : Array(depth).fill("..").join("/");
}

const Skeleton: React.FC<React.PropsWithChildren<{ b: string }>> = ({ children, b }) => (
    <html>
        <head>
            <title>Taya Crystals</title>
            <meta charSet="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <link rel="stylesheet" href={`${b}/.assets/styles.css`} />
            <link rel="icon" href={`${b}/.assets/favicon.png`} />
        </head>
        <body>
            {children}
        </body>
        <footer>
            <p>Made by Taya<br />Feel free to copy</p>
        </footer>
    </html>
);

const WindowSection: React.FC<{ path: string; children: React.ReactNode }> = ({ path, children }) => (
    <section className="window">
        <h2>
            <a href="/">/home</a>
            <span>{path}</span>
        </h2>
        {children}
    </section>
);

const DirectoryListing: React.FC<{
    path: string;
    items: { name: string; href: string; icon: string }[];
    b: string;
}> = ({ path, items, b }) => (
    <Skeleton b={b}>
        <h1>Taya Crystals</h1>
        <WindowSection path={path}>
            <div className="icon-grid">
                {items.map(item => (
                    <a key={item.name} href={item.href}>
                        <img src={`${b}/.assets/icons/${item.icon}`} alt={item.name} />
                        <span>{item.name}</span>
                    </a>
                ))}
            </div>
        </WindowSection>
    </Skeleton>
);

const HtmlViewer: React.FC<{ path: string; content: string; b: string }> = ({ path, content, b }) => (
    <Skeleton b={b}>
        <h1>Taya Crystals</h1>
        <WindowSection path={path}>
            <div className="file-viewer">
                <div dangerouslySetInnerHTML={{ __html: content }} />
            </div>
        </WindowSection>
    </Skeleton>
);

// ── Build ─────────────────────────────────────────────────────────────────────

if (fs.existsSync(DIST)) fs.rmSync(DIST, { recursive: true });
fs.mkdirSync(DIST);

fs.cpSync(join(ROOT, ".assets"), join(DIST, ".assets"), { recursive: true });

// ── Compile Typst résumés to PDF ───────────────────────────────────────────────

const RESUME_DIR = join(ROOT, "resume_src");
const typFiles = fs.readdirSync(ROOT).filter(f => f.endsWith(".typ"));
if (typFiles.length > 0) {
    fs.mkdirSync(RESUME_DIR, { recursive: true });
    for (const typ of typFiles) {
        fs.copyFileSync(join(ROOT, typ), join(RESUME_DIR, typ));
    }
    const photoSrc = join(ROOT, "photo.png");
    if (fs.existsSync(photoSrc)) {
        fs.copyFileSync(photoSrc, join(RESUME_DIR, "photo.png"));
    }
    for (const typ of typFiles) {
        const pdfName = typ.replace(/\.typ$/, ".pdf");
        const pdfPath = join(ROOT, pdfName);
        const proc = Bun.spawnSync(["typst", "compile", join(RESUME_DIR, typ), pdfPath], {
            stdout: "inherit",
            stderr: "inherit",
        });
        if (!proc.success) {
            console.error(`typst failed for ${typ}`);
            process.exit(1);
        }
    }
    fs.rmSync(RESUME_DIR, { recursive: true });
}

async function processDir(fsPath: string, urlPath: string) {
    const entries = fs.readdirSync(fsPath).filter(e => !e.startsWith(".") && !e.endsWith(".typ") && e !== "photo.png");

    entries.sort((a, b) => {
        const aDir = fs.statSync(join(fsPath, a)).isDirectory();
        const bDir = fs.statSync(join(fsPath, b)).isDirectory();
        if (aDir !== bDir) return aDir ? 1 : -1;
        const ae = a.split(".").pop() ?? "";
        const be = b.split(".").pop() ?? "";
        return ae < be ? -1 : ae > be ? 1 : 0;
    });

    const items: { name: string; href: string; icon: string }[] = [];

    for (const entry of entries) {
        const entryPath = join(fsPath, entry);
        const relPath = urlPath ? `${urlPath}/${entry}` : entry;

        if (fs.statSync(entryPath).isDirectory()) {
            items.push({ name: entry, href: `${entry}/`, icon: "folder.png" });
            await processDir(entryPath, relPath);
        } else if (entry.endsWith(".lnk")) {
            const href = (await Bun.file(entryPath).text()).trim();
            items.push({
                name: entry,
                href,
                icon: entry === "email.lnk" ? "mail.png" : "link.png",
            });
        } else if (entry.endsWith(".html")) {
            const content = await Bun.file(entryPath).text();
            const b = assetBase(relPath);
            const out = join(DIST, relPath);
            fs.mkdirSync(dirname(out), { recursive: true });
            fs.writeFileSync(
                out,
                `<!DOCTYPE html>${renderToStaticMarkup(<HtmlViewer path={`/${relPath}`} content={content} b={b} />)}`
            );
            items.push({ name: entry, href: entry, icon: "file.png" });
        } else {
            const out = join(DIST, relPath);
            fs.mkdirSync(dirname(out), { recursive: true });
            fs.copyFileSync(entryPath, out);
            let icon = "unknown.png";
            if (/\.(jpe?g|png|gif|webp|svg)$/i.test(entry)) icon = "image.png";
            else if (/\.(pdf|txt)$/i.test(entry)) icon = "file.png";
            items.push({ name: entry, href: entry, icon });
        }
    }

    const indexRelPath = urlPath ? `${urlPath}/index.html` : "index.html";
    const b = assetBase(indexRelPath);
    const out = join(DIST, indexRelPath);
    fs.mkdirSync(dirname(out), { recursive: true });
    fs.writeFileSync(
        out,
        `<!DOCTYPE html>${renderToStaticMarkup(
            <DirectoryListing path={urlPath ? `/${urlPath}` : ""} items={items} b={b} />
        )}`
    );
}

await processDir(ROOT, "");

console.log("Built → ./dist/");
