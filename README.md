# web-to-android

Build an Android app that shows a URL in a fullscreen web view.

## Usage

- Copy `sample.env` and change values as necessary.
- Run `./scripts/create_app.sh`.
- (Optionally) Update icons and any other changes in generated `OUT_DIR/PROJECT` folder.
- Run `docker compose up` to generate your apk file in `OUT_DIR`.

`./scripts/run.sh` can be used for build + run on adb connected device.
