
library(dplyr)
library(purrr)
# setwd("C:/Users/ftw712/Desktop/private-sector-publishing/")
#
ss = readr::read_tsv("data/source.tsv") %>% 
mutate(pd = ifelse(grepl("publisher",link),"publisher","dataset")) %>% 
mutate(key = gsub("https://www.gbif.org/publisher/","",link)) %>%
mutate(key = gsub("https://www.gbif.org/dataset/","",key)) %>% 
glimpse()

gbif_country = rgbif::enumeration_country() %>% select(Country=title,iso2) %>% glimpse()

pp = ss %>%
dplyr::filter(pd == "publisher") %>%
select(key,`Activity sector`) %>% 
mutate(name = map_chr(key,~rgbif::dataset_search(publishingOrg=.x,limit=1)$data$publishingOrganization)) %>% 
mutate(`Occurrence records` = map_dbl(key,~ rgbif::occ_search(publishingOrg = .x,occurrenceStatus=NULL,limit=0)$meta$count)) %>% 
mutate(Datasets = map_dbl(key,~rgbif::dataset_search(publishingOrg= .x,limit=0)$meta$count)) %>% 
mutate(`Data citations` = map_dbl(key,~rgbif::lit_count(publishingOrg = .x))) %>%
mutate(Company = paste0("https://www.gbif.org/publisher/",key,"[",name,"]")) %>%
mutate(iso2 = map_chr(key,~rgbif::dataset_search(publishingOrg=.x,limit=1)$data$publishingCountry)) %>%
merge(gbif_country,by="iso2") %>%
glimpse()

dd = ss %>% 
dplyr::filter(pd == "dataset") %>%
select(key,`Activity sector`) %>% 
mutate(name = map_chr(key,~rgbif::datasets(uuid=.x,limit=1)$data$title)) %>%
mutate(`Occurrence records` = map_dbl(key,~
rgbif::occ_search(datasetKey = .x,occurrenceStatus=NULL,limit=0)$meta$count)) %>%
mutate(Datasets = 1) %>% 
mutate(`Data citations` = map_dbl(key,~rgbif::lit_count(datasetKey = .x))) %>%
mutate(Company = paste0("(https://www.gbif.org/dataset/",key,")[",name,"]")) %>% 
mutate(p_key = map_chr(key,~ rgbif::datasets(uuid=.x,limit=1)$data$publishingOrganizationKey)) %>%
mutate(iso2 = map_chr(p_key,~rgbif::dataset_search(publishingOrg=.x,limit=1)$data$publishingCountry)) %>%
merge(gbif_country,by="iso2") %>%
select(-p_key) %>%
glimpse()

tt = rbind(pp,dd) %>% 
arrange(name) %>%
select(Company, `Activity sector`,	Country, Datasets, `Occurrence records`, `Data citations`) %>%
glimpse() 

# save tsv
save_file_tsv = paste0("exports/tsv/table-",Sys.Date(),".tsv")
tt %>% readr::write_tsv(save_file_tsv)

# save .adoc
save_file_table = paste0("exports/table/table-",Sys.Date(),".adoc")

sink(file = save_file_table, type = "output")
tt %>%  
mutate(`Datasets` = format(`Datasets`, nsmall=0, big.mark=",")) %>%
mutate(`Occurrence records` = format(`Occurrence records`, nsmall=0, big.mark=",")) %>%
mutate(`Data citations` = format(`Data citations`, nsmall=0, big.mark=",")) %>%
ascii::ascii(include.rownames = FALSE, digits = 0)
sink()

# totals table
save_file_totals = paste0("exports/totals/table-totals-",Sys.Date(),".adoc")

sink(file = save_file_totals, type = "output")
tt %>% 
summarise(
Datasets = sum(Datasets),
`Occurrence records` = sum(`Occurrence records`), 
`Data citations` = sum(`Data citations`)
) %>%
mutate(`Datasets` = format(`Datasets`, nsmall=0, big.mark=",")) %>%
mutate(`Occurrence records` = format(`Occurrence records`, nsmall=0, big.mark=",")) %>%
mutate(`Data citations` = format(`Data citations`, nsmall=0, big.mark=",")) %>%
ascii::ascii(include.rownames = FALSE, digits = 0)
sink()

list.files("exports/totals/")
list.files("exports/table/")
list.files("exports/tsv/")