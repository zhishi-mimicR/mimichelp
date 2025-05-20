#' install
#'
#' @param token token
#'
#' @return install
#' @export
#'
install_nwR <- function(token,version){
    e <- tryCatch(detach(paste0("package:nwR",version), unload = TRUE),error=function(e) 'e')
    # check
    (td <- tempdir(check = TRUE))
    td2 <- '1'
    while(td2 %in% list.files(path = td)){
        td2 <- as.character(as.numeric(td2)+1)
    }
    (dest <- paste0(td,'/',td2))
    do::formal_dir(dest)
    dir.create(path = dest,recursive = TRUE,showWarnings = FALSE)
    (tf <- paste0(dest,'/nwR.zip'))

    if (do::is.windows()){
        download.file(url = sprintf('https://codeload.github.com/zhishi-mimicR/nwR%s_win/zip/refs/heads/main',version),
                      destfile = tf,
                      mode='wb',
                      headers = c(NULL,Authorization = sprintf("token %s",token)))
        unzip(zipfile = tf,exdir = dest,overwrite = TRUE)
    }else{
        download.file(url = sprintf('https://codeload.github.com/zhishi-mimicR/nwR%s_mac/zip/refs/heads/main',version),
                      destfile = tf,
                      mode='wb',
                      headers = c(NULL,Authorization = sprintf("token %s",token)))
        unzip(zipfile = tf,exdir = dest,overwrite = TRUE)
    }

    if (do::is.windows()){
        main <- paste0(dest,sprintf('/nwR%s_win-main',version))
        (nwR <- list.files(main,paste0('nwR',version),full.names = TRUE))
        (nwR <- nwR[do::right(nwR,3)=='zip'])
        (k <- do::Replace0(nwR,sprintf('.*nwR%s_',version),'\\.zip','\\.tgz','\\.') |> as.numeric() |> which.max())
        unzip(nwR[k],files = sprintf('nwR%s/DESCRIPTION',version),exdir = main)
    }else{
        (main <- paste0(dest,sprintf('/nwR%s_mac-main',version)))
        (nwR <- list.files(main,paste0('nwR',version),full.names = TRUE))
        (nwR <- nwR[do::right(nwR,3)=='tgz'])
        (k <- do::Replace0(nwR,sprintf('.*nwR%s_',version),'\\.zip','\\.tgz','\\.') |> as.numeric() |> which.max())
        untar(nwR[k],files = sprintf('nwR%s/DESCRIPTION',version),exdir = main)
    }

    # 检查需要安装的包是否安装
    (desc <- paste0(main,'/nwR',version))
    check_package(desc)

    # 检查是否安装了nwR，把data拷贝过来
    # (gf <- paste0(.libPaths(),'/nwR',version))
    # (gf <- gf[file.exists(gf)])
    # copydata <- F
    # if (length(gf)>0){
    #     (gf <- gf[1])
    #     (gfs <- paste0(gf,'/data'))
    #     if (file.exists(gfs) & length(list.files(gfs))>0){
    #         (todata <- paste0(do::file.dir(nwR[k]),'/data'))
    #         copy_with_structure(gfs,todata)
    #         copydata <- T
    #     }
    # }

    install.packages(pkgs = nwR[k],repos = NULL,quiet = FALSE)
    # if (copydata){
    #     if (!dir.exists(gfs)) dir.create(gfs,showWarnings = F,recursive = T)
    #     copy_with_structure(todata,gfs)
    # }


    message('Done(nwR)')
    x <- suppressWarnings(file.remove(list.files(dest,recursive = TRUE,full.names = TRUE)))
    invisible()
}

