DAPLAB Official Documentation
=============

This repo holds the official documentation of the DAPLAB, compiled and deployed at the following 
URL: [http://docs.daplab.ch](http://docs.daplab.ch)

The current documentation relies havily on [Markdown](https://daringfireball.net/projects/markdown/)
for the syntaxe and [Mkdocs](http://www.mkdocs.org/) for the static generation.

# Build the doc

```bash
mkdocs compile
```

This will produce a folder `site` with the static site inside.

# Deploy the doc

The documentation is hosted on `vsccproxy1-brn`. Once the the `site` folder is up-to-date, 
you can simply `rsync` the folder to the proxy server.

```bash
rsync -av site/ daplab-wn-12:/var/www/docs.daplab.ch
```

A convenient script, [generate-docs.sh](generate-doc.sh), is capturing all that. Just launch
it to deploy the new version

```bash
./publish-doc.sh
```

# References

* https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
* https://pythonhosted.org/Markdown/extensions/
* https://github.com/ocefpaf/python4oceanographers_intro_course/blob/master/mkdocs.yml
* https://github.com/gajus/gitdown (requires running `node /usr/local/bin/gitdown`)

## Simplify your life generating Markdown Tables

* http://www.tablesgenerator.com/markdown_tables

