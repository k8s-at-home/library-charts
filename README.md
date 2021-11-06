# Library Charts

# Helm charts
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-10-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

Most of our application Helm charts consume our Common library Helm chart.

## Background

In Helm 3, their team introduced the concept of a
[Library chart](https://helm.sh/docs/topics/library_charts/).

> A library chart is a type of Helm chart that defines chart primitives or
  definitions which can be shared by Helm templates in other charts. This
  allows users to share snippets of code that can be re-used across charts,
  avoiding repetition and keeping charts DRY.

The common library was created because we saw many charts requiring only a
few select configuration options in their Helm charts.

In order to stay somewhat DRY (Don't Repeat Yourself) and keeping with Helm 3
usage for a Library chart, we saw this pattern and decided it was worth it for
us to create a library. This means each one of these app charts has a
dependency on what we call the `common` library.

## Changelog

To view the changelog for the common library see
[here](https://github.com/k8s-at-home/library-charts/tree/main/charts/stable/common#changelog).

## Support

We have a few outlets for getting support with our projects:

- Visit our [Docs](https://docs.k8s-at-home.com/).
- Bugs or feature requests should be opened in an [issue](https://github.com/k8s-at-home/library-charts/issues/new/choose).
- Questions or comments should be discussed in our [Discord](https://discord.gg/sTMX7Vh) or via [GitHub discussions](https://github.com/k8s-at-home/organization/discussions).

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/bjw-s"><img src="https://avatars.githubusercontent.com/u/6213398?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Bᴇʀɴᴅ Sᴄʜᴏʀɢᴇʀs</b></sub></a><br /><a href="https://github.com/k8s-at-home/library-charts/commits?author=bjw-s" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/onedr0p"><img src="https://avatars.githubusercontent.com/u/213795?v=4?s=100" width="100px;" alt=""/><br /><sub><b>ᗪєνιη ᗷυнʟ</b></sub></a><br /><a href="https://github.com/k8s-at-home/library-charts/commits?author=onedr0p" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/angelnu"><img src="https://avatars.githubusercontent.com/u/4406403?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Angel Nunez Mencias</b></sub></a><br /><a href="https://github.com/k8s-at-home/library-charts/commits?author=angelnu" title="Code">💻</a></td>
    <td align="center"><a href="https://winston.milli.ng/"><img src="https://avatars.githubusercontent.com/u/6162814?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Winston R. Milling</b></sub></a><br /><a href="https://github.com/k8s-at-home/library-charts/commits?author=wrmilling" title="Code">💻</a></td>
    <td align="center"><a href="https://cajun.pro/"><img src="https://avatars.githubusercontent.com/u/15788890?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Nicholas St. Germain</b></sub></a><br /><a href="https://github.com/k8s-at-home/library-charts/commits?author=dirtycajunrice" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/billtomturner"><img src="https://avatars.githubusercontent.com/u/65121940?v=4?s=100" width="100px;" alt=""/><br /><sub><b>billtomturner</b></sub></a><br /><a href="https://github.com/k8s-at-home/library-charts/commits?author=billtomturner" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/jr0dd"><img src="https://avatars.githubusercontent.com/u/285797?v=4?s=100" width="100px;" alt=""/><br /><sub><b>jr0dd</b></sub></a><br /><a href="https://github.com/k8s-at-home/library-charts/commits?author=jr0dd" title="Code">💻</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/allenporter"><img src="https://avatars.githubusercontent.com/u/6026418?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Allen Porter</b></sub></a><br /><a href="https://github.com/k8s-at-home/library-charts/commits?author=allenporter" title="Documentation">📖</a></td>
    <td align="center"><a href="http://alexbabel.com"><img src="https://avatars.githubusercontent.com/u/13570439?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Alex Babel</b></sub></a><br /><a href="https://github.com/k8s-at-home/library-charts/commits?author=AlexanderBabel" title="Code">💻</a></td>
    <td align="center"><a href="https://ciangallagher.net"><img src="https://avatars.githubusercontent.com/u/4751449?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Cian Gallagher</b></sub></a><br /><a href="https://github.com/k8s-at-home/library-charts/commits?author=Cian911" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
