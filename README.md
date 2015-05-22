## Atom.io Plugin - Wercker Status

Add Wercker status of the project to the Atom status bar.

![Full editor screenshot](https://raw.github.com/felipefdl/wercker-status/master/screenshots/full_editor.png)

## Code Status
[![wercker status](https://app.wercker.com/status/f0845e5ad84b372173d3839a3e8596e1/s "wercker status")](https://app.wercker.com/project/bykey/f0845e5ad84b372173d3839a3e8596e1)

[![Dependency Status](https://gemnasium.com/felipefdl/wercker-status.svg)](https://gemnasium.com/felipefdl/wercker-status)

## Installing
You will find this package in "atom" packages in the settings.
or run `apm install wercker-status` from the command line.

## Using
The Wercker build status for your repository will be indicated by the message in the status bar.

In the first time after installation , you need to configuration the library, with your user and password, you will find the fields in "atom" settings. The user and password erase when get token.

The status Wercker operates automatically, identifying your project and getting the status of the build. But you can also use the following hotkeys:
* `shift-ctrl-W` - Hotkey to check status in Windows/Linux
* `shift-cmd-W` - Hotkey to check status in Mac OS X
* `wercker-status:checknow` - Use this command to bind other command.

And you can find the "Wercker status" in  menu "Packages".

## License

Atom Wercker Status is released under the [MIT License](https://github.com/felipefdl/wercker-status/blob/master/LICENSE.md).
