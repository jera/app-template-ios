fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

## Choose your installation method:

<table width="100%" >
<tr>
<th width="33%"><a href="http://brew.sh">Homebrew</a></td>
<th width="33%">Installer Script</td>
<th width="33%">Rubygems</td>
</tr>
<tr>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS or Linux with Ruby 2.0.0 or above</td>
</tr>
<tr>
<td width="33%"><code>brew cask install fastlane</code></td>
<td width="33%"><a href="https://download.fastlane.tools/fastlane.zip">Download the zip file</a>. Then double click on the <code>install</code> script (or run it in a terminal window).</td>
<td width="33%"><code>sudo gem install fastlane -NV</code></td>
</tr>
</table>
# Available Actions
## iOS
### ios refresh_dsyms
```
fastlane ios refresh_dsyms
```

### ios init_date_build
```
fastlane ios init_date_build
```

### ios set_branch_release_version
```
fastlane ios set_branch_release_version
```

### ios certificates_prod
```
fastlane ios certificates_prod
```
Matches certificates and provisioning profiles for production
### ios certificates_dev
```
fastlane ios certificates_dev
```
Matches certificates and provisioning profiles for development
### ios certificates
```
fastlane ios certificates
```
Matches certificates and provisioning profiles
### ios deploy_local
```
fastlane ios deploy_local
```
Submit a new Beta Build to Apple TestFlight from local machine

This will also make sure the profile is up to date
### ios deploy
```
fastlane ios deploy
```
Submit a new Beta Build to Apple TestFlight

This will also make sure the profile is up to date
### ios test
```
fastlane ios test
```

### ios upload_to_appetize
```
fastlane ios upload_to_appetize
```
Build your app and upload it to Appetize to stream it in your browser
### ios addBetaBadge
```
fastlane ios addBetaBadge
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
