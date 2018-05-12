# Localizations #
This shells are from [KeepingYouAwake](https://github.com/newmarcel/KeepingYouAwake)

This folder is intended as export location for Xcode's *"Export for Localizations…"* feature.

## XLIFF ##

If you want to add a localization to PrincessGuide, please use these XLIFF files as reference, e.g. `ja.xliff`. You can then import them in Xcode.

XLIFF files should be committed with any new translation and will be kept up-to-date during development.

## Scripts ##

This directory contains helper scripts to import/export localizations.

- `export.sh`: Exports all localizations
- `import.sh`: Imports all localizations from the `PrincessGuide` sub directory
- `update.sh`: Exports/Imports all translations
    - after the execution, all XLIFF files should be in sync
- `config.sh`: contains the list of translations in the `TRANSLATIONS` variable
    - please update this when you add translations
