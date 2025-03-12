require(magrittr)
require(devtools)
require(xml2)


build_vig <- T
if(build_vig){
  devtools::install_github("ECarnell/SpatialUKCEH",
                           ref = "main",
                           build_vignettes = T,
                           auth_token = Sys.getenv("GITHUBTOKEN"))
  devtools::install_github("ECarnell/AgricInvUKCEH",
                           ref = "main",
                           build_vignettes = T,
                           auth_token = Sys.getenv("GITHUBTOKEN"))
}
require(SpatialUKCEH)
setwd("~/ECarnell.github.io/")
create_dir("./html/")



# Create a new HTML document
index_html <- read_html("./index_template.html")

# Add title and subheading
body_node <- xml_find_first(index_html, "//body")




lib_pth <- .libPaths() %>% .[grepl("AppData",.)]

vgn <- paste0(lib_pth,"/AgricInvUKCEH/doc/") %>% list.files(pattern = ".html",recursive = T,
                                                             full.names = T)

vgn <- vgn[!grepl("index",vgn)]

subheading_node <- xml_add_child(body_node, "h2", "AgricInvUKCEH package:")

for(v in vgn){
print(v)
bse <- basename(v)
nme <- bse %>% gsub("_"," ",.) %>% gsub("\\.html","",.)
nw_fl <- paste0("./html/",bse)

file.copy(from = v,
          to = nw_fl,
          overwrite = T)
  
new_link <- paste0('<a href="html/',bse,'">',nme,'</a>')
link_node <- xml_add_child(body_node, "a", nme, href = paste0("html/", bse))
xml_add_child(body_node, "br")

}


vgn <- paste0(lib_pth,"/SpatialUKCEH/doc/") %>% list.files(pattern = ".html",recursive = T,
                                                            full.names = T)

vgn <- vgn[!grepl("index",vgn)]

subheading_node <- xml_add_child(body_node, "h2", "SpatialUKCEH package:")

for(v in vgn){
  print(v)
  bse <- basename(v)
  nme <- bse %>% gsub("_"," ",.) %>% gsub("\\.html","",.)
  nw_fl <- paste0("./html/",bse)
  
  file.copy(from = v,
            to = nw_fl,
            overwrite = T)
  
  new_link <- paste0('<a href="html/',bse,'">',nme,'</a>')
  link_node <- xml_add_child(body_node, "a", nme, href = paste0("html/", bse))
  xml_add_child(body_node, "br")
  
}
write_html(index_html, "./index.html")
