<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a id="readme-top"></a>

<!--  *** Thanks for checking out the Best-README-Template. If you have a suggestion that would make this better, please fork the repo and create a pull request or simply open an issue with the tag "enhancement". Don't forget to give the project a star! Thanks again! Now go create something AMAZING! :D -->



<!-- /// d   u   b   p   i   x   e   l  ---  f   o   r   k   ////--v0.5.7 -->
<!--this has additionally been modifed by @dubpixel for hardware use -->
<!--search dpx_again-n-again.. search & replace is COMMAND OPTION F -->

<!--this is the version for software -->



<!-- PROJECT SHIELDS -->
<!-- *** I'm using markdown "reference style" links for readability. Reference links are enclosed in brackets [ ] instead of parentheses ( ). See the bottom of this document for the declaration of the reference variables for contributors-url, forks-url, etc. This is an optional, concise syntax you may use. https://www.markdownguide.org/basic-syntax/#reference-style-links -->
<div align="center">

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]
</div>
<!-- PROJECT LOGO -->
<div align="center">
<h1 align="center">dpx_again-n-again</h1>
<h3 align="center"><i>drag an app in, get a launcher that opens another copy of it</i></h3>
  <p align="center">
    A tiny macOS droplet: drop any installed app onto it and it builds a double-clickable launcher in <code>~/Applications</code> that opens a <i>new</i> instance every time, so you can run multiple copies side by side.
    <br />
     »  
     <a href="https://github.com/dubpixel/dpx_again-n-again"><strong>Project Here!</strong></a>
     »  
     <br />
    <a href="https://github.com/dubpixel/dpx_again-n-again/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    ·
    <a href="https://github.com/dubpixel/dpx_again-n-again/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
    </p>
</div>
   <br />
<!-- TABLE OF CONTENTS -->
<details>
  <summary><h3>Table of Contents</h3></summary>
<ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>    
    <li><a href="#how-it-works">How it works</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
</ol>
</details>
<!-- ABOUT THE PROJECT -->
<details>
<summary><h3>About The Project</h3></summary>

**What it does.** `AgainNAgain.app` is a drop target. Drag any installed app onto its icon and it writes a small launcher app, `<Name>Again.app`, into `~/Applications`. Double-click that launcher and macOS opens a **new instance** of the app, every time, even if one is already running. Launch it five times, get five copies.

**Why.** macOS normally refuses to start a second copy of an app that is already running, but some apps (control software, [Tessera Remote](https://www.bromptontech.com/) for LED processors, instances pointed at different devices, etc.) are routinely needed several times at once. `open -n` forces a fresh instance, and this project wraps that in something you can drag, drop and pin to the Dock or a Stream Deck. It started life as [dpx_tr_again](https://github.com/dubpixel/dpx_tr_again), a single-purpose launcher for Tessera Remote; this is the open-ended version.

**Version-aware.** If the dropped app's name ends in a version (`Tessera Remote 3.5.2`), the generated launcher doesn't hardcode it. It searches `/Applications`, `~/Applications` and the folder the app came from for `Tessera Remote` / `Tessera Remote <number>`, sorts by version (3.10.0 beats 3.5.2) and opens the newest. Update the app and the launcher just follows. Apps without a version in the name are opened by their exact path.

*Unofficial; not affiliated with Brompton Technology or any app you wrap. Product names belong to their owners.*

**Keywords:** run multiple instances of an app on macOS, open second copy of an app, open -n launcher generator, macOS multi-instance, Tessera Remote multiple copies, droplet.
</br>

*author(s): // www.dubpixel.tv  - i@dubpixel.tv | other authors* 
</details>
<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With 

 * AppleScript droplet (`osacompile`), POSIX `sh` generator, no dependencies, no build tooling beyond macOS
 * macOS `open -n`, `defaults`, `codesign` (ad-hoc), `hdiutil`
 * GitHub Pages (Jekyll) for the project site

<p align="right">(<a href="#readme-top">back to top</a>)</p>
<!-- GETTING STARTED -->

## Getting Started

  ### Prerequisites
  * macOS (uses only built-in tools)

  ### Installation

  **Option A: build it locally (recommended).** Nothing is downloaded as an app, so there is no transfer damage and macOS never quarantines it. Installs to `~/Applications`:

  ```sh
  curl -fsSL https://raw.githubusercontent.com/dubpixel/dpx_again-n-again/main/install.sh | sh
  ```

  **Option B: DMG.** Download `AgainNAgain-vX.Y.Z.dmg` from the [Releases page](https://github.com/dubpixel/dpx_again-n-again/releases), open it and drag the app onto *Applications*. (Downloaded apps are quarantined; see below.)

  ### If macOS blocks it

  This only applies to Option B or any copy that was emailed or downloaded. The app is not signed or notarized with a developer ID, so macOS may say it "can't be opened" or is "damaged". Either:

  * open **System Settings → Privacy & Security**, scroll down and click **Open Anyway**, or
  * run this in Terminal (adjust the path):

    ```sh
    xattr -dr com.apple.quarantine /Applications/AgainNAgain.app
    ```

  Launchers *generated by* the droplet are built on your Mac, so they are never quarantined.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->
## Usage

1. Open `AgainNAgain.app` (or just have it handy in Finder).
2. Drag an installed app (from `/Applications`, say) onto the `AgainNAgain` icon.
3. Finder reveals the new `<Name>Again.app` in `~/Applications`. Drag it to the Dock or a Stream Deck button.
4. Each double-click opens another copy of the app.

Command-line equivalent (what the droplet runs for you):

```sh
src/make-again.sh "/Applications/Some App 1.2.app"            # version-aware
src/make-again.sh --exact "/Applications/Some App 1.2.app"    # pin to this exact app
src/make-again.sh --out ~/Desktop "/Applications/Some App.app"
```

Generated names have no spaces (`Tessera Remote` becomes `TesseraRemoteAgain`) on purpose, so a launcher can never match its own search pattern.

<!-- HOW IT WORKS -->
## How it works

A macOS `.app` is just a folder. If it contains an executable file at `Contents/MacOS/<name>`, double-clicking the app runs that file, and the file can be a plain shell script. Everything here is built on that.

**The simplest possible launcher**, by hand:

```sh
mkdir -p ~/Applications/MyLauncher.app/Contents/MacOS

cat > ~/Applications/MyLauncher.app/Contents/MacOS/MyLauncher <<'EOF'
#!/bin/sh
open -n '/Applications/Some App.app'
EOF

chmod +x ~/Applications/MyLauncher.app/Contents/MacOS/MyLauncher
```

* `#!/bin/sh` tells macOS how to run the file.
* `open -n` opens a **new** instance even when the app is already running.
* `chmod +x` (plus) marks it executable.
* A minimal `Contents/Info.plist` (`CFBundleExecutable`, `CFBundleIdentifier`, `CFBundlePackageType`) makes it behave more reliably on other Macs.

**What this project adds on top** is automation:

| Piece | What it's for |
|-------|---------------|
| `src/droplet.applescript` | An AppleScript droplet: macOS hands it whatever you drop on its icon |
| `src/make-again.sh` | Writes the launcher app: script, `Info.plist`, and the target app's own icon |
| Name stripping + `sort -V` | Turns `Foo 3.5.2` into a "newest `Foo`" search so launchers survive upgrades |
| Spaceless output name | A launcher can never match its own search |
| `build.sh` / `install.sh` | Compile the droplet, bundle the generator, re-sign ad-hoc, package zip/DMG, or install locally |

If you only need one fixed app, the six-line version above is enough.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

  <!-- ROADMAP -->
## Roadmap

- [x] Drop an app, get an `open -n` launcher in `~/Applications`
- [x] Version-aware launchers (`sort -V`)
- [x] Borrow the wrapped app's icon
- [ ] Badge the generated icon so it's distinguishable from the original
- [ ] Optional "also pass these arguments" field

See the [open issues](https://github.com/dubpixel/dpx_again-n-again/issues) for a full list of proposed features (and known issues).

<!-- CONTRIBUTING -->
## Contributing

_Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**._

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Top contributors:
<a href="https://github.com/dubpixel/dpx_again-n-again/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=dubpixel/dpx_again-n-again" alt="contrib.rocks image" />
</a>

<!-- LICENSE -->
## License
Distributed under the MIT License. Commercial use is allowed; keep the copyright notice and attribution. See `LICENSE` for more information.
<!-- CONTACT -->
## Contact

  ### Joshua Fleitell - i@dubpixel.tv

  Project Link: [https://github.com/dubpixel/dpx_again-n-again](https://github.com/dubpixel/dpx_again-n-again)

<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

<!--
  * [ ]() - the best !
-->

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/dubpixel/dpx_again-n-again.svg?style=flat-square
[contributors-url]: https://github.com/dubpixel/dpx_again-n-again/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/dubpixel/dpx_again-n-again.svg?style=flat-square
[forks-url]: https://github.com/dubpixel/dpx_again-n-again/network/members
[stars-shield]: https://img.shields.io/github/stars/dubpixel/dpx_again-n-again.svg?style=flat-square
[stars-url]: https://github.com/dubpixel/dpx_again-n-again/stargazers
[issues-shield]: https://img.shields.io/github/issues/dubpixel/dpx_again-n-again.svg?style=flat-square
[issues-url]: https://github.com/dubpixel/dpx_again-n-again/issues
[license-shield]: https://img.shields.io/github/license/dubpixel/dpx_again-n-again.svg?style=flat-square
[license-url]: https://github.com/dubpixel/dpx_again-n-again/blob/main/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=flat-square&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/jfleitell
[product-front]: images/front.png
[product-rear]: images/rear.png
[product-front-rendering]: images/front_render.png
[product-rear-rendering]: images/rear_render.png
[product-pcbFront]: images/pcb_front.png
[product-pcbRear]: images/pcb_rear.png
[Next.js]: https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white
[Next-url]: https://nextjs.org/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://reactjs.org/
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/
[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[Svelte-url]: https://svelte.dev/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com 
[KiCad.org]: https://img.shields.io/badge/KiCad-v8.0.6-blue
[KiCad-url]: https://kicad.org 
[Fusion-360]: https://img.shields.io/badge/Fusion360-v4.2.0-green
[Autodesk-url]: https://autodesk.com 
[FastLed.io]: https://img.shields.io/badge/FastLED-v3.9.9-red
[FastLed-url]: https://fastled.io 
