# imports a .txt file of duration data, converts the duration variable to hh:mm:ss (hms) format, and exports the resulting data to an rda file.

fls_tags_importer is used to import a .txt file of duration data
generated with kid3 audio tagger (https://kid3.kde.org/)

## Usage

``` r
fls_tags_importer(myfilename = NULL)
```

## Arguments

- myfilename:

  the full path and filename of the file to be imported and converted.

## Details

fls_tags_importer

## Examples

``` r
fls_tags_importer(myfilename = "C:/Users/alexm/Music/fls_tags.txt")
#> Error in (function (path, write = FALSE, call = caller_env()) {    if (is.raw(path)) {        return(rawConnection(path, "rb"))    }    if (!is.character(path)) {        return(path)    }    if (is_url(path)) {        ext <- tolower(tools::file_ext(path))        if (ext %in% c("gz", "bz2", "xz", "zip")) {            cli::cli_abort("Remote compressed files must be handled upstream of this function.",                 .internal = TRUE)        }        if (requireNamespace("curl", quietly = TRUE)) {            con <- curl::curl(path)        }        else {            inform("`curl` package not installed, falling back to using `url()`")            con <- url(path)        }        return(con)    }    path <- enc2utf8(path)    if (write) {        path <- normalizePath_utf8(path, mustWork = FALSE)    }    else {        path <- check_path(path)    }    p <- split_path_ext(basename_utf8(path))    extension <- p$extension    formats <- archive_formats(extension)    while (is.null(formats) && nzchar(extension)) {        extension <- split_path_ext(extension)$extension        formats <- archive_formats(extension)    }    needs_archive <- !is.null(formats) && (write || extension !=         "zip")    if (needs_archive) {        reason <- glue("to {if (write) 'write' else 'read'} `.{p$extension}` files.")        rlang::check_installed("archive", reason = reason, call = call)        if (write) {            if (is.null(formats[[1]])) {                return(archive::file_write(path, filter = formats[[2]]))            }            return(archive::archive_write(path, p$path, format = formats[[1]],                 filter = formats[[2]]))        }        if (is.null(formats[[1]])) {            return(archive::file_read(path, filter = formats[[2]]))        }        return(archive::archive_read(path, format = formats[[1]],             filter = formats[[2]]))    }    if (!write) {        compression <- detect_compression(path)    }    else {        compression <- NA    }    if (is.na(compression)) {        compression <- tools::file_ext(path)    }    if (write && compression == "zip") {        cli::cli_abort(c("Can only read from, not write to, {.val .zip} files.",             i = "Install the {.pkg archive} package to write {.val .zip} files."),             call = call)    }    switch(compression, gz = gzfile(path), bz2 = bzfile(path),         xz = xzfile(path), zip = zipfile(path), if (!has_trailing_newline(path)) {            file(path)        } else {            path        })})("C:/Users/alexm/Music/fls_tags.txt"): C:/Users/alexm/Music/fls_tags.txt does not exist.

```
