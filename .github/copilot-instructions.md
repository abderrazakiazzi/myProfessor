# Copilot instructions for MyProfessor

This file gives concise, project-specific guidance so an AI coding agent can be productive immediately.

## Big-picture architecture
- This is an Angular 18 application with Server-Side Rendering (SSR). Key pieces:
  - Browser entry: [src/main.ts](src/main.ts)
  - Server entry: [src/main.server.ts](src/main.server.ts) and SSR bootstrap exported by that file.
  - Express SSR host: [server.ts](server.ts) — uses `@angular/ssr` CommonEngine to render pages.
  - Build output: `dist/my-professor` per [angular.json](angular.json) (server and browser folders under that output).

## Important files to inspect
- Project metadata and scripts: [package.json](package.json)
- Angular CLI config: [angular.json](angular.json)
- Server host: [server.ts](server.ts)
- App bootstrap configs: [src/app/app.config.ts](src/app/app.config.ts) and [src/app/app.config.server.ts](src/app/app.config.server.ts)
- Root component: [src/app/app.component.ts](src/app/app.component.ts)
- Routing stub: [src/app/app.routes.ts](src/app/app.routes.ts)
- CI pipeline: [Jenkinsfile](Jenkinsfile) and `jenkins/scripts/*`

## Developer workflows & exact commands
- Local development (dev server with live reload): `npm start` (runs `ng serve`).
- Build (browser + server per angular.json): `npm run build` (runs `ng build`).
- Watch build during development: `npm run watch`.
- Run tests: `npm test` (Karma).
- Run SSR server after a production build (the package.json helper expects the built server bundle at `dist/my-professor/server/server.mjs`): `npm run serve:ssr:myProfessor` which executes `node dist/my-professor/server/server.mjs`.
- CI: Jenkinsfile runs `npm install` then executes `jenkins/scripts/deliver.sh` and `jenkins/scripts/kill.sh`.

Notes: prefer executing npm scripts defined in `package.json` to avoid CLI/flag mismatches.

## Project-specific patterns & conventions
- Standalone components: components are declared with `standalone: true` and bootstrapped with `bootstrapApplication` ([src/main.ts](src/main.ts), [src/main.server.ts](src/main.server.ts)).
- Application config is provided via `appConfig` and merged with a server-only `config` for SSR ([src/app/app.config.ts], [src/app/app.config.server.ts]). Look here for DI providers such as `provideZoneChangeDetection`, `provideClientHydration`, and `provideServerRendering`.
- Routing currently uses an empty `routes` array in [src/app/app.routes.ts]; add route entries there and register with `provideRouter` in the `appConfig`.
- Static assets are served from the `public/` folder (configured in `angular.json` assets).
- TypeScript targeting: ES2022 modules and `moduleResolution: bundler` (see [tsconfig.json](tsconfig.json)). Keep emitted module formats in mind when running the server bundle.

## SSR specifics and debugging tips
- The Express host ([server.ts](server.ts)) expects the browser output under `dist/my-professor/browser` and the server bundle to be runnable (server.mjs). To debug SSR locally:
  1. Run `npm run build` to produce `dist/my-professor` artifacts.
  2. Start server bundle with `npm run serve:ssr:myProfessor` (or `node dist/my-professor/server/server.mjs`).
 3. Monitor logs printed by the Express server in the console to troubleshoot rendering errors.

## What to change in PRs / code edits
- When adding new providers for the app, prefer adding to `appConfig` so the same DI is used for both browser and server. If provider is server-only, add it to `app.config.server.ts` and merge it there.
- Keep routing changes in `src/app/app.routes.ts` to avoid duplication.
- Static assets go into `public/` and are referenced in `angular.json`.

## Tests and CI
- Unit tests: Karma configured; run `npm test`.
- Jenkins pipeline: ensure any changes to build outputs or script names are reflected in `Jenkinsfile` and `jenkins/scripts/*`.

## Quick examples (copyable)
- Start dev server: `npm start`
- Build and run SSR server locally:

  npm run build
  npm run serve:ssr:myProfessor

## If something is missing
- If a required script or build target is not present, inspect [angular.json](angular.json) to find builder targets and use `ng run <project>:<target>`.

---
If anything here is unclear or you'd like the guidance expanded (examples for adding routes, creating a new standalone component, or SSR troubleshooting steps), tell me which area to expand.
