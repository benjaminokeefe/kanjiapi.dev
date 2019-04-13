# KanjiApi

Source for [https://kanjiapi.dev/](https://kanjiapi.dev/)

## Development:

### Requirements:

Assumes `python 2.7`, `brew` and `make` are available.

### Setup:

`brew install xq`

Save the kanji dictionary file `kanjidic2.xml` from [EDRDG](http://www.edrdg.org/wiki/index.php/KANJIDIC_Project) to the root of the project.

Save the jmdict dictionary file `JMdict_e` from [EDRDG](http://www.edrdg.org/wiki/index.php/JMdict-EDICT_Dictionary_Project) to the root of the project.

### Building:

Run `make` to build the site and API endpoints as static assets.

### Deployment (Requires google cloud account credentials):

After building, to sync the built assets to the website bucket run:

`gsutil -m -h "Content-Type:application/json" rsync -d -x *.html -x *.css out/site gs://kanjiapi-static`
`gsutil -m rsync -d -x kanji/* -x reading/* out/site gs://kanjiapi-static`

(a good idea to run with `rsync -n` for dry-run first)

#### Renewing SSL certificate:

The SSL certificate is only trusted for a certain amount of time, the below script mostly automates
the process of getting a new certificate

`./update_cert.sh`

#### Setting CORS policy:

The CORS policy is stored in `cors.json`, it can be updated by editing this file and running `gsutil cors set cors.json gs://kanjiapi-static`

### Useful JQ recipes:

Print out all kanji as `literal: meaning`
`jq '.kanjidic2.character | map([.literal, .reading_meaning.rmgroup.meaning])[] | if (.[1]|type)=="array" then "\(.[0]): \(.[1][0])" else "\(.[0]): \(.[1])" end'`

Count kanji with n meanings
`cat out/kanjidic2.json | jq '.kanjidic2.character[] | .reading_meaning.rmgroup.meaning | if (.|type)=="array" then map(select((.|type)=="string")) else [.] end | length' | sort -V | uniq -c`
