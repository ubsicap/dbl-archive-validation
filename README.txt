Digital Bible Library Validation
********************************

This project contains schema for validating data uploaded to the Digital Bible Library (DBL). It also contains examples of valid data files.

Branches
========

default - Where current development is committed
dbl2.0 - Schema versions for DBL website version 2.0 (in quality assurance testing 27.MAR.2012).

Layout
======

├── build/ ...compiled versions of schema, mirroring structure of source/
├── converttorng
├── converttorng.bat
├── README.txt
├── source
│   ├── audio
│   │   └── 1.0
│   │       ├── license.rnc
│   │       ├── license.xml
│   │       ├── metadatakeys.csv
│   │       ├── metadata.rnc
│   │       ├── metadata.xml
│   │       └── source.xml
│   ├── licenserights.csv
│   ├── notes_on_metatdatkeys.txt
│   └── text
│       ├── 1.1
│       │   ├── metadatakeys_LEGACY_ONLY.csv
│       │   ├── metadata.rnc
│       │   ├── metadata.xml
│       │   ├── styles.rnc
│       │   ├── styles.xml
│       │   └── usx.rnc
│       └── 1.2
│           ├── license.rnc
│           ├── license.xml
│           ├── metadatakeys.csv
│           ├── metadata.rnc
│           ├── metadata-tgrahamproposal.rnc
│           ├── metadata.xml
│           ├── styles.rnc
│           ├── styles.xml
│           ├── usx_ChangeLog.txt
│           └── usx.rnc
└── trang.jar # relaxng compact form compile

10 directories, 35 files
