require(magrittr)
require(devtools)
require(xml2)
require(SpatialUKCEH)
create_dir("./html/")

setwd("~/ECarnell.github.io/")

# Create a new HTML document
index_html <- read_html("<html><head><title>Vignettes</title></head><body></body></html>")

# Add title and subheading
body_node <- xml_find_first(index_html, "//body")
title_node <- xml_add_child(body_node, "h1", "Vignettes")
subheading_node <- xml_add_child(body_node, "h2", "Explore the vignettes below:")

devtools::install_github("ECarnell/AgricInvUKCEH",
                         ref = "main",
                         build_vignettes = T,
                         auth_token = Sys.getenv("GITHUBTOKEN"))


lib_pth <- .libPaths() %>% .[grepl("AppData",.)]

vgn <- paste0(lib_pth,"/AgricInvUKCEH/doc/") %>% list.files(pattern = ".html",recursive = T,
                                                             full.names = T)

vgn <- vgn[!grepl("index",vgn)]




for(v in vgn){
print(v)
bse <- basename(v)
nme <- bse %>% gsub("_"," ",.) %>% gsub("\\.html","",.)
nw_fl <- paste0("./html/",bse)

file.copy(from = v,
          to = nw_fl)
  
new_link <- paste0('<a href="html/',bse,'">',nme,'</a>')
link_node <- xml_add_child(body_node, "a", nme, href = paste0("html/", bse))
xml_add_child(body_node, "br")

}
write_html(index_html, "./index.html")
