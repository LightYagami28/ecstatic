# Ecstatic

[GitHub Repository](http://github.com/jgm/ecstatic)

## Description

Ecstatic is a framework for managing a static website. Pages are generated from Tenjin templates and YAML data files, providing a simple and efficient way to maintain static content while separating data from presentation.

## Features

- **Static Site Generation**: Build fast and secure websites.
- **Separation of Data and Presentation**: Like dynamic web frameworks, but using text files instead of databases.
- **Markdown Support**: Easily integrate markdown for content.
- **Output Options**: Supports HTML, plain text, and LaTeX formats for the generated pages.

## Usage

### Initial Setup

Start by generating a new site skeleton:

```bash
ecstatic mysite
```

Navigate into your project directory to see the created files:

```bash
cd mysite
ls
```

### Build the Site

To generate the site in the `site` directory, run:

```bash
rake
```

### Customization

You can customize the site by modifying the following files:

- Layout: `standard.rbhtml`
- Data: `events.yaml`
- Template: `events.rbhtml`

Recompile the site with `rake` after making changes.

### Adding New Pages

To add new pages:

1. Add new templates and data files.
2. Register them in `siteindex.yaml`.
3. Place any static files in the `files` directory (they will be copied as-is).

### Using Markdown

If a page has no dynamic elements (besides layout handling), you can use a Markdown file instead of a template. Just give it a `.markdown` extension.

## Requirements

- `rpeg-markdown`
- `tenjin`
- `activesupport`

## Installation

Install Ecstatic via RubyGems:

```bash
sudo gem install ecstatic
```

## License

BSD License

Copyright (c) 2009 John MacFarlane

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
