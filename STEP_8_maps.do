*******************************************************************************
* 25/09/2024
* Ángel Sánchez Daniel
*
* SHARE Database - Maps creation for Phd Chapter 2: Time use and wealth transfers
*
* The purpose of this code is:
* 1.- Create maps of Europe with stats from SHARE
*******************************************************************************

*******************************************************************************
* WORKFLOW

* Main (root) folder: 

* 2.wealth_transfers_gender

* Sub_folders

* dofiles : Stata scripts
* GIS : Spatial files (maps)
* graphs : Figures exported here (figures)
* master : Final datasets (database)
* raw : Raw data
* temp : Intermediate files here
*******************************************************************************
 
********************************************************************************
* NOW LETS TRY WITH OUR DATA
********************************************************************************

* STEP 1.- Prepare base map 
****************************
clear all

* set working diretory where the .shp is allocated
cd "C:\Users\angel\OneDrive - Universidad de Salamanca\9.- Doctorado\2.wealth_transfers_gender\maps"

* Convert shapefiles into stata files
spshape2dta "World_Countries.shp", replace saving(world)

* Check if the files are working
use world, clear
spmap using world_shp, id(_ID) // identifier of each region

use world_shp, clear

*** plot what we have
scatter _Y _X, msize(tiny) 

/*

*I comment these lines because there are unnecesary
*I will clip the part of the map I need using other clip packages
*And I dont need to change the projection

*** plot without the territories
keep if _X > -20 & _X < 45 & _Y > 25 & _Y < 75    // get rid of the part we dont want
scatter _Y _X, msize(tiny)   

*** plot with the correct projection
geo2xy _Y _X, proj (web_mercator) replace  // change projection
scatter _Y _X, msize(tiny)  


* We drop and change projection to mercator
foreach x in world {
  
  use `x'_shp, clear
    keep if _X > -21 & _X < 46 & _Y > 26 & _Y < 76    // get rid of the part we dont want        
    *geo2xy _Y _X, proj(web_mercator) replace
  save `x'_shp_mercator, replace // Notice that this is replacing the original
}
*/

* STEP 2.- Clip base map to extent and prepare the map
*********************

*clear all

*cd "C:\Users\angel\OneDrive - Universidad de Salamanca\9.- Doctorado\2.wealth_transfers_gender\maps"

* Package for clipping
*ssc install clipgeo, replace

* other package needed
* ssc install gtools, replace
* ssc install carryforward, replace

* Clip world_shp map
clippolygon world_shp, box(-20, 45, 25, 75) method(box)

* Base map
use world, clear
spmap using world_shp_clipped, id(_ID)

/*
use world, clear
spmap using world_shp_mercator, id(_ID)
*super awkward, I think I should clip the shp or sthing
* lets try clip


clippolygon world_shp_mercator, box(45, 75, -20, 25) method(box)
clippolygon world_shp_mercator, box(134, 141, -92, -87) method(box)
* Aqui está la clave de porque los label no funcionan, se cambia los puntos

use world_shp_mercator, clear


*** plot what we have
scatter _Y _X, msize(tiny) 

*/

* Add color depending on numeric values of countries

spmap _ID using world_shp_clipped, id(_ID) cln(5) fcolor(Heat)

* Place legend in the correct place

spmap _ID using world_shp_clipped, ///
 id(_ID) cln(5) fcolor(Heat) ///
 legend(pos(11) size(2.5)) legstyle(2)

* STEP 3.- First version of the maps
**************************************

* Path for database
cd "C:\Users\Angel\OneDrive - Universidad de Salamanca\9.- Doctorado\2.wealth_transfers_gender\database"

merge 1:1 COUNTRY using data_country_gift
drop _merge
merge 1:1 COUNTRY using data_country_gender_gap
drop _merge
merge 1:1 COUNTRY using data_country_time_use
drop _merge

* Path for maps (where shapefiles are saved)
cd "C:\Users\angel\OneDrive - Universidad de Salamanca\9.- Doctorado\2.wealth_transfers_gender\maps"

* To improve I should move all gen and label and renames to previous do-files and merge just the variables I want to

* Plot the received_gift
spmap received_gift using world_shp_clipped, ///
 id(_ID) cln(5) fcolor(Heat) ///
 legend(pos(11) size(2.5))  legstyle(2) 
 
* Path for figures
cd "C:\Users\Angel\OneDrive - Universidad de Salamanca\8.- Proyectos LaTeX\2.- PhD_chapter_2\figures"
 
graph export map_received_gift.png, replace

* Path for maps (where shapefiles are saved)
cd "C:\Users\angel\OneDrive - Universidad de Salamanca\9.- Doctorado\2.wealth_transfers_gender\maps"

* Plot the received_large_gift
spmap received_large_gift using world_shp_clipped, ///
 id(_ID) cln(5) fcolor(Heat) ///
 legend(pos(11) size(2.5))  legstyle(2) 

* Path for figures
cd "C:\Users\Angel\OneDrive - Universidad de Salamanca\8.- Proyectos LaTeX\2.- PhD_chapter_2\figures" 
graph export map_received_large_gift.png, replace
 
* Path for maps (where shapefiles are saved)
cd "C:\Users\angel\OneDrive - Universidad de Salamanca\9.- Doctorado\2.wealth_transfers_gender\maps" 

* Plot the gap chores
spmap gap_chores using world_shp_clipped, ///
 id(_ID) cln(5) fcolor(Heat) ///
 legend(pos(11) size(2.5))  legstyle(2) 

* Path for figures
cd "C:\Users\Angel\OneDrive - Universidad de Salamanca\8.- Proyectos LaTeX\2.- PhD_chapter_2\figures" 
graph export map_gap_chores.png, replace
 
* Path for maps (where shapefiles are saved)
cd "C:\Users\angel\OneDrive - Universidad de Salamanca\9.- Doctorado\2.wealth_transfers_gender\maps" 

* Plot the gap paid work
spmap gap_paid_work using world_shp_clipped, ///
 id(_ID) cln(5) fcolor(Heat) ///
 legend(pos(11) size(2.5))  legstyle(2) 

* Path for figures
cd "C:\Users\Angel\OneDrive - Universidad de Salamanca\8.- Proyectos LaTeX\2.- PhD_chapter_2\figures" 
graph export map_gap_paid_work.png, replace
 
* Path for maps (where shapefiles are saved)
cd "C:\Users\angel\OneDrive - Universidad de Salamanca\9.- Doctorado\2.wealth_transfers_gender\maps" 

* Plot the gap leisure
spmap gap_leisure using world_shp_clipped, ///
 id(_ID) cln(5) fcolor(Heat) ///
 legend(pos(11) size(2.5))  legstyle(2) 

* Path for figures
cd "C:\Users\Angel\OneDrive - Universidad de Salamanca\8.- Proyectos LaTeX\2.- PhD_chapter_2\figures" 
graph export map_gap_leisure.png, replace

* Path for maps (where shapefiles are saved)
cd "C:\Users\angel\OneDrive - Universidad de Salamanca\9.- Doctorado\2.wealth_transfers_gender\maps"

* Plot the min on chores
spmap min_chores using world_shp_clipped, ///
 id(_ID) cln(5) fcolor(Heat) ///
 legend(pos(11) size(2.5))  legstyle(2) 
 
* Path for figures
cd "C:\Users\Angel\OneDrive - Universidad de Salamanca\8.- Proyectos LaTeX\2.- PhD_chapter_2\figures" 
graph export map_time_use_chores.png, replace
 
* Path for maps (where shapefiles are saved)
cd "C:\Users\angel\OneDrive - Universidad de Salamanca\9.- Doctorado\2.wealth_transfers_gender\maps"

* Plot the min on paid work
spmap min_paid_work using world_shp_clipped, ///
 id(_ID) cln(5) fcolor(Heat) ///
 legend(pos(11) size(2.5))  legstyle(2) 

* Path for figures
cd "C:\Users\Angel\OneDrive - Universidad de Salamanca\8.- Proyectos LaTeX\2.- PhD_chapter_2\figures" 
graph export map_time_use_paid_work.png, replace
 
* Path for maps (where shapefiles are saved)
cd "C:\Users\angel\OneDrive - Universidad de Salamanca\9.- Doctorado\2.wealth_transfers_gender\maps" 

* Plot the min on leisure
spmap min_leisure using world_shp_clipped, ///
 id(_ID) cln(5) fcolor(Heat) ///
 legend(pos(11) size(2.5))  legstyle(2) 

* Path for figures
cd "C:\Users\Angel\OneDrive - Universidad de Salamanca\8.- Proyectos LaTeX\2.- PhD_chapter_2\figures" 
graph export map_time_use_leisure.png, replace
 

* STEP 4.- Improve labels
**************************

 
*******************************************************************************
* Next steps:
* 1.- Improve the legend
* 2.- Use black-to-white scheme
* 3.- Put lines in the rest of the countries
* 4.- Automate map creation (everything is super repetitive so I could do some kind of automation)








/*
* Notes from course in https://github.com/asjadnaqvi
*******************************************************************************
* MAPS IN STATA
*******************************************************************************

clear all

* Package to change maps projections
*ssc install geo2xy, replace

* Package for graphs
*ssc install schemepack, replace

* Set scheme in white background
set scheme white_tableau, perm

* Ben Jann's palette package
*ssc install palettes, replace

* Set default graph font to Arial Narrow
graph set window fontface "Arial Narrow"

* Packages for spatial graphs
*ssc install spmap, replace
*ssc install shp2dta, replace
*ssc install mif2dta, replace

*******************************************************************************
* European maps
*******************************************************************************

cd "C:\Users\angel\OneDrive - Universidad de Salamanca\9.- Doctorado\2.wealth_transfers_gender\GIS"

copy "https://github.com/asjadnaqvi/The-Stata-Guide/blob/master/data/demo_r_pjangrp3_clean.dta" "demo_r_pjangrp3_clean.dta.dta", replace

copy "https://github.com/asjadnaqvi/The-Stata-Guide/blob/master/data/demo_r_pjanind3_clean.dta" "demo_r_pjanind3_clean.dta.dta", replace


* Convert shapefiles into stata files

spshape2dta "NUTS_RG_03M_2016_4326_LEVL_0.shp", replace saving(nuts0)
spshape2dta "NUTS_RG_03M_2016_4326_LEVL_1.shp", replace saving(nuts1)
spshape2dta "NUTS_RG_03M_2016_4326_LEVL_2.shp", replace saving(nuts2)
spshape2dta "NUTS_RG_03M_2016_4326_LEVL_3.shp", replace saving(nuts3)

* Check if the files are working

use nuts0, clear
spmap using nuts0_shp, id(_ID) // identifier of each region
use nuts1, clear
spmap using nuts1_shp, id(_ID)
use nuts2, clear
spmap using nuts2_shp, id(_ID)
use nuts3, clear
spmap using nuts3_shp, id(_ID)


* We use NUTS 0 and get rid of small islands

use nuts0_shp, clear

*** plot what we have
scatter _Y _X, msize(tiny) 
 
*** plot without the territories
keep if _X > -10 & _Y >20    // get rid of the small islands
scatter _Y _X, msize(tiny)   

*** plot with the correct projection
geo2xy _Y _X, proj (web_mercator) replace  // change projection
scatter _Y _X, msize(tiny)  


* We drop small islands and change projection to mercator in the 4 shp
foreach x in nuts0 nuts1 nuts2 nuts3 {
  
  use `x'_shp, clear
    keep if _X > -10 & _Y >20        
    geo2xy _Y _X, proj(web_mercator) replace
  save `x'_shp, replace // Notice that this is replacing the original
}


* Base map

use nuts0, clear
spmap using nuts0_shp, id(_ID)

* Add color depending on numeric values of countries

spmap _ID using nuts0_shp, id(_ID) cln(5) fcolor(Heat)

* Place legend in the correct place

spmap _ID using nuts0_shp, ///
 id(_ID) cln(5) fcolor(Heat) ///
 legend(pos(11) size(2.5)) legstyle(2)
 

/* THIS PART IS BROKEN FOR THE MOMENT 
 
* Generate file with country labels
* This should be done manually

use nuts0, clear
gen ctry_name = ""
replace ctry_name = "Albania"     if NUTS_ID=="AL"
replace ctry_name = "Austria"     if NUTS_ID=="AT"
replace ctry_name = "Belgium"     if NUTS_ID=="BE"
replace ctry_name = "Bulgaria"    if NUTS_ID=="BG"
replace ctry_name = "Switzerland" if NUTS_ID=="CH"
replace ctry_name = "Czechia"     if NUTS_ID=="CZ"
replace ctry_name = "Cyprus"      if NUTS_ID=="CY"
replace ctry_name = "Germany"     if NUTS_ID=="DE"
replace ctry_name = "Denmark"     if NUTS_ID=="DK"
replace ctry_name = "Estonia"     if NUTS_ID=="EE"
replace ctry_name = "Spain"       if NUTS_ID=="ES"
replace ctry_name = "Finland"     if NUTS_ID=="FI"
replace ctry_name = "France"      if NUTS_ID=="FR"
replace ctry_name = "Greece"      if NUTS_ID=="EL"
replace ctry_name = "Croatia"     if NUTS_ID=="HR"
replace ctry_name = "Hungary"     if NUTS_ID=="HU"
replace ctry_name = "Ireland"     if NUTS_ID=="IE"
replace ctry_name = "Italy"       if NUTS_ID=="IT"
replace ctry_name = "Lichtenstein"   if NUTS_ID=="LI"
replace ctry_name = "Lithuania"   if NUTS_ID=="LT"
replace ctry_name = "Luxembourg"  if NUTS_ID=="LU"
replace ctry_name = "Latvia"      if NUTS_ID=="LV"
replace ctry_name = "Montenegro"  if NUTS_ID=="ME"
replace ctry_name = "North Macedonia"  if NUTS_ID=="MK"
replace ctry_name = "Malta"       if NUTS_ID=="MT"
replace ctry_name = "Netherlands" if NUTS_ID=="NL"
replace ctry_name = "Norway"      if NUTS_ID=="NO"
replace ctry_name = "Poland"      if NUTS_ID=="PL"
replace ctry_name = "Portugal"    if NUTS_ID=="PT"
replace ctry_name = "Romania"     if NUTS_ID=="RO"
replace ctry_name = "Serbia"      if NUTS_ID=="RS"
replace ctry_name = "Sweden"      if NUTS_ID=="SE"
replace ctry_name = "Slovenia"    if NUTS_ID=="SI"
replace ctry_name = "Slovakia"    if NUTS_ID=="SK"
replace ctry_name = "Turkey"      if NUTS_ID=="TR" 
replace ctry_name = "United Kingdom"  if NUTS_ID=="UK"
// fix some "displaced" labels 
replace _CX = _CX + 4 if NUTS_ID=="FR"  // france
replace _CY = _CY + 4 if NUTS_ID=="FR"
replace _CX = _CX - 1 if NUTS_ID=="SE"  // sweden
keep _ID _CY _CX NUTS_ID ctry_name
compress
save nuts0_labels, replace

* Now the map with the labels

use nuts0, clear
spmap _ID using nuts0_shp, ///
 id(_ID) cln(5) fcolor(Heat) ///
 legend(pos(11) size(2.5)) legstyle(2) ///
 label(data("nuts0_labels") x(_CX) y(_CY) label(ctry_name) color(black) size(1.5))
*/

* Building a regional map and merging with .dta

use nuts3, clear

*** add demographic data
merge 1:1 NUTS_ID using demo_r_pjanind3_clean
drop if _m==2 // UK removed
drop _m 


* Plot the median age (yMEDAGEPOP)
spmap yMEDAGEPOP using nuts3_shp, ///
 id(_ID) cln(5) fcolor(Heat) ///
 legend(pos(11) size(2.5))  legstyle(2) 
 * ///
 *label(data(nuts0_labels) x(_CX) y(_CY) label(ctry_name) color(black) size(1.5))
 
 * LABELS ARE STILL BROKEN I DONT KNOW WHY
 
* Formatting legend. It is the same as format in stata

format yMEDAGEPOP %9.2f
spmap yMEDAGEPOP using nuts3_shp, ///
 id(_ID) cln(10) clm(k) fcolor(Heat) ///
 legend(pos(11) size(2.5))  legstyle(2) 
 * ///
 *label(data(nuts0_labels) x(_CX) y(_CY) label(ctry_name) color(black) size(1.5))
 
* Improve legend in blocks of 5

spmap yMEDAGEPOP using nuts3_shp, ///
 id(_ID) clm(custom) clbreaks(15(5)60)   fcolor(Heat) ///
 legend(pos(11) size(2.5))  legstyle(2) 
 * ///
 *label(data(nuts0_labels) x(_CX) y(_CY) label(ctry_name) color(black) size(1.5))
 
*/
