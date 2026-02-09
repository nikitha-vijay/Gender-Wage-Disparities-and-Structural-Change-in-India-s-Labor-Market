
** get the total wage for each day of the week

**2023

gen day1_earnings = b6q9_act2_3pt7_perv1 + b6q9_3pt7_perv1
gen day2_earnings = b6q9_act2_3pt6_perv1 + b6q9_3pt6_perv1
gen day3_earnings = b6q9_act2_3pt5_perv1 + b6q9_3pt5_perv1
gen day4_earnings = b6q9_act2_3pt4_perv1 + b6q9_3pt4_perv1
gen day5_earnings b6q9_act2_3pt3_perv1 + b6q9_3pt3_perv1
gen day6_earnings = b6q9_act2_3pt2_perv1 + b6q9_3pt2_perv1
gen day7_earnings = b6q9_act2_3pt1_perv1 + b6q9_3pt1_perv1

**2018
 gen day1_earnings = b6q9_Act1_3pt7 + b6q9_Act2_3pt7
 gen day2_earnings = b6q9_Act2_3pt6 + b6q9_3pt6_Act1
 gen day3_earnings = b6q9_3pt5_Act2 + b6q9_3pt5_Act1_per_fv
 gen day4_earnings = b6q9_3pt4_Act2_per_fv + b6q9_3pt4_Act1_per_fv
 gen day5_earnings = b6q9_3pt3_Act2_per_fv + b6q9_3pt3_Act1_per_fv
 gen day6_earnings = b6q9_3pt2_Act2_per_fv + b6q9_3pt2_Act1_per_fv
 gen day7_earnings = b6q9_3pt1_Act2_per_fv + b6q9_3pt1_Act1_per_fv


** generate the daily earnings variable

gen daily_earning = earnings_casual

** replace entries having 0 with the regular wage earnings and self-employed earnings
replace daily_earning = earnings_regular if daily_earning == 0
replace daily_earning = earnings_self if daily_earning == 0

** drop entries where the value of daily earnings equal zero
drop if daily_earning == 0

** generate the required weight
gen final_weight = mult/100 if nss==nsc
replace final_weight = mult/200 if nss!=nsc 

gen f_state = state + sector + stratum + substratum

** tell stata that you are working with survey data
svyset fsu [pw=final_weight], strata(f_state)
 
** obtaining employment share by industry according to industry code given as per NIC 2008 - kuznets process
svy: tab industry_name

** get the names of the industries
gen industry_name = ""

gen industry_name = ""


replace industry_name = "Agriculture" if industry_code == "01" | industry_code == "02" | industry_code == "03"
replace industry_name = "Mining and Quarrying" if industry_code == "05" | industry_code == "06" | industry_code == "07" | industry_code == "08" | industry_code == "09"
replace industry_name = "Manufacturing" if inrange(industry_code, 10, 33)
replace industry_name = "Electricity, Gas, Steam and Air Conditioning Supply" if industry_code == "35"
replace industry_name = "Water Supply, Sewerage, Waste Management" if industry_code == "36" | industry_code == "37" | industry_code == "38" | industry_code == "39"
replace industry_name = "Construction" if industry_code == "41" | industry_code == "42" | industry_code == "43"
replace industry_name = "Wholesale and Retail Trade" if industry_code == "45" | industry_code == "46" | industry_code == "47"
replace industry_name = "Transportation and Storage" if industry_code=="49"|industry_code=="50"|industry_code=="51"|industry_code=="52"|industry_code=="53"
replace industry_name = "Accommodation and Food Service Activities" if industry_code == "55" | industry_code == "56"
replace industry_name = "Information and Communication" if industry_code=="58"|industry_code=="59"|industry_code=="60"|industry_code=="61"|industry_code=="62"|industry_code=="63"
replace industry_name = "Financial and Insurance Activities" if industry_code == "64" | industry_code == "65" | industry_code == "66"
replace industry_name = "Real Estate Activities" if industry_code == "68"
replace industry_name = "Professional, Scientific and Technical Activities" if industry_code == "69" | industry_code =="70"|industry_code=="71"|industry_code=="72"|industry_code=="73"|industry_code=="74"|industry_code=="75"
replace industry_name = "Administrative and Support Service Activities" if industry_code=="77"|industry_code=="78"|industry_code=="79"|industry_code=="80"|industry_code=="81"|industry_code=="82"
replace industry_name = "Public Administration and Defence" if industry_code == "84"
replace industry_name = "Education" if industry_code == "85"
replace industry_name = "Human Health and Social Work Activities" if industry_code == "86" | industry_code == "87" | industry_code == "88"
replace industry_name = "Arts, Entertainment and Recreation" if industry_code == "90" | industry_code == "91" | industry_code == "92" | industry_code == "93"


replace industry_name = "Manufacturing" if industry_code >= "10" & industry_code <= "33"

** creating a variable for employment status type - lewis process
gen type = 1 if earnings_casual !=0
replace type = 2 if earnings_regular !=0
replace type = 3 if earnings_self !=0

svy: tab type

** rural-urban share in employment - Harris Todaro
tab sector 

** calculating average wage based on gender

gen maleday1_earnings = b6q9_act2_3pt7_perv1 + b6q9_3pt7_perv1 if gender == "1"
gen maleday2_earnings = b6q9_act2_3pt6_perv1 + b6q9_3pt6_perv1 if gender == "1"
gen maleday3_earnings = b6q9_act2_3pt5_perv1 + b6q9_3pt5_perv1 if gender == "1"
gen maleday4_earnings = b6q9_act2_3pt4_perv1 + b6q9_3pt4_perv1 if gender == "1"
gen maleday5_earnings= b6q9_act2_3pt3_perv1 + b6q9_3pt3_perv1   if gender == "1"
gen maleday6_earnings = b6q9_act2_3pt2_perv1 + b6q9_3pt2_perv1 if gender == "1"
gen maleday7_earnings = b6q9_act2_3pt1_perv1 + b6q9_3pt1_perv1 if gender == "1"

** daily male earnings for casual labour

gen earnings_casual_male = (maleday1_earnings+maleday2_earnings+maleday3_earnings+maleday4_earnings+maleday5_earnings+maleday6_earnings+maleday7_earnings)/7

gen daily_earning_male = earnings_casual_male if gender=="1"
replace daily_earning_male = earnings_regular if daily_earning == 0 & gender=="1"
replace daily_earning_male = earnings_self if daily_earning == 0 & gender=="1"


drop if daily_earning_male==0
drop if daily_earning_male==.


replace industry_name = "Utilities" if industry_code == "35" | industry_code =="36" | industry_code == "37" | industry_code == "38" | industry_code == "39"

replace industry_name = "Services excluding Public" if industry_code == "45" | industry_code == "46" | industry_code == "47" | industry_code == "49" | industry_code == "50" | industry_code =="51" | industry_code == "53" | industry_code == "55" | industry_code == "56" | industry_code == "58" | industry_code == "59" | industry_code == "59" | industry_code == "60" | industry_code == "61" | industry_code == "62" | industry_code == "63" | industry_code == "64" | industry_code == "65" | industry_code == "66" | industry_code == "68" | industry_code == "69" | industry_code == "70" | industry_code == "71" | industry_code == "72" | industry_code == "73" | industry_code == "74" | industry_code == "75" | industry_code == "77" | industry_code == "78" | industry_code == "79" | industry_code == "80" | industry_code == "81" | industry_code == "82" | industry_code == "85" | industry_code == "86" | industry_code == "87" | industry_code == "88" | industry_code == "90" | industry_code == "91" | industry_code == "92" | industry_code == "93" | industry_code == "94"  | industry_code == "96"  | industry_code == "97" | industry_code == "95" | industry_code == "52"


replace industry_name = "Public Administration and Defence" if industry_code == "84"



import excel "C:\Users\Nikitha\Desktop\Dissertation\Consolidated Data for Dissertation - final copy.xlsx", sheet("Industry - Female") firstrow
sort Industry Year 
bysort Industry (Year): gen d_emp_share = EmploymentShare - EmploymentShare[_n-1] 
bysort Industry (Year): gen d_wage = AverageDailyWage - AverageDailyWage[_n-1]
gen term1 = d_emp_share * AverageDailyWage
gen term2 = EmploymentShare[_n-1] * d_wage
gen total_wage_change = term1 + term2
collapse (sum) term1 term2, by(Year Industry total_wage_change )


import excel "C:\Users\Nikitha\Desktop\Dissertation\Consolidated Data for Dissertation - final copy.xlsx", sheet("Industry - Female") firstrow
sort Industry Year 
bysort Industry (Year): gen d_emp_share = EmploymentShare - EmploymentShare[_n-1] 
bysort Industry (Year): gen d_wage = AverageDailyWage - AverageDailyWage[_n-1]
gen term1 = d_emp_share * AverageDailyWage
gen term2 = EmploymentShare[_n-1] * d_wage
gen total_wage_change = term1 + term2
collapse (sum) term1 term2, by(Year Industry total_wage_change)









