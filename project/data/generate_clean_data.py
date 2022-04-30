

countries_names = './original_data/country_names_and_codes.csv'
country_table = './cleaned_data/country.csv'

gdp_per_capita = './original_data/gdp_per_capita_uncleaned_data.csv'
gdp_US_dollar = './original_data/gdp_US_dollar_uncleaned_data.csv'
country_GDP_table = './cleaned_data/countryGDP.csv'

employment_rate = './original_data/employment_rate_uncleaned_data.csv'
employment_table = './cleaned_data/employment.csv'

employment_by_age = './original_data/employment_by_age_uncleaned_data.csv'
employment_by_age_table = './cleaned_data/employment_by_age.csv'

employment_by_education = './original_data/employment_by_education_uncleaned_data.csv'
employment_by_education_table = './cleaned_data/employment_by_education.csv'

employment_by_enterprise = './original_data/employment_by_enterprise_uncleaned_data.csv'
employment_by_enterprise_table = './cleaned_data/employment_by_enterprise.csv'

# special groups of countries that we want to delete from teh original dataset, since we want to look at each country seprately.
special_groups = ['EU27_2020', 'G20', 'G7', 'OECD', 'EA19', 'OECDE', 'G-7', 'G-20', 'OAVG']

import csv

#******************* Countries Table ******************#
def get_countries_gdp():
    allCountries = set()
    allLines = {}
    # reading gdp values
    with open(gdp_US_dollar, 'r', encoding='utf-8-sig') as file:
        csv_file = csv.DictReader(file)
        for row in csv_file:
            D = dict(row)
            # we only want the data starting from 2016
            if int(D['TIME']) >= 2016 and D['LOCATION'] not in special_groups:
                allCountries.add(D['LOCATION'])
                if (D['LOCATION'], D['TIME'])  not in allLines:
                    allLines[(D['LOCATION'], D['TIME'])] = ['NULL', 'NULL']
                allLines[(D['LOCATION'], D['TIME'])][0] = D['Value'] # gdp is at index 0

    # reading gdpPerCapita values
    with open(gdp_per_capita, 'r', encoding='utf-8-sig') as file:
        csv_file = csv.DictReader(file)
        for row in csv_file:
            D = dict(row)
            if int(D['TIME']) >= 2016 and D['LOCATION'] not in special_groups:
                # gdp_per_capita is at index 1
                allLines[(D['LOCATION'], D['TIME'])][1] = D['Value']

    # writing to Countries_gdp Table
    with open(country_GDP_table, mode='w') as file_to_write:
        fieldnames = ['countryCode', 'year', 'gdp', 'gdpPerCapita']
        writer = csv.DictWriter(file_to_write, fieldnames=fieldnames)

        # writer.writeheader()
        for t in allLines:
            countryCode = t[0]
            year = t[1]
            gdp = allLines[t][0]
            gdpPerCapita = allLines[t][1]
            writer.writerow({'countryCode': countryCode, 'year': year, 'gdp': gdp, 'gdpPerCapita': gdpPerCapita})

    # get the countries names
    allLines = {}
    with open(countries_names, 'r', encoding='utf-8-sig') as file:
        csv_file = csv.DictReader(file)
        for row in csv_file:
            D = dict(row)
            allLines[D['3_char_code']] = D['country_name'] # gdp is at index 0

    # Country Table
    with open(country_table, mode='w') as file_to_write:
        fieldnames = ['countryCode', 'countryName']
        writer = csv.DictWriter(file_to_write, fieldnames=fieldnames)
        # writer.writeheader()
        for c in allLines:
            countryCode = c
            countryName = allLines[c]
            writer.writerow({'countryCode': countryCode, 'countryName': countryName})

#*******************    Employment Table ******************#

def get_employment():
    allLines = {}
    # reading employment_rate values
    with open(employment_rate, 'r', encoding='utf-8-sig') as file:
        csv_file = csv.DictReader(file)
        for row in csv_file:
            D = dict(row)
            if int(D['TIME']) >= 2016 and D['LOCATION'] not in special_groups:
                allLines[(D['LOCATION'], D['TIME'])] = D['Value']
    # Employment Table
    with open(employment_table, mode='w') as file_to_write:
        fieldnames = ['countryCode', 'year', 'employmentRate']
        writer = csv.DictWriter(file_to_write, fieldnames=fieldnames)
        # writer.writeheader()
        for t in allLines:
            countryCode = t[0]
            year = t[1]
            employmentRate = allLines[t]
            writer.writerow({'countryCode': countryCode, 'year': year, 'employmentRate': employmentRate})

#*******************    EmploymentByAge Table ******************#

def get_employment_by_age():
    allLines = {}

    # reading employmentByRate
    with open(employment_by_age, 'r', encoding='utf-8-sig') as file:
        csv_file = csv.DictReader(file)
        for row in csv_file:
            D = dict(row)
            location = D['LOCATION']
            year = D['TIME']
            if int(year) >= 2016 and int(year) <= 2019 and location not in special_groups:
                if (location, year, D['SUBJECT']) not in allLines:
                    allLines[(location, year, D['SUBJECT'])] = D['Value']

    # writing to EmploymentByAge Table
    ageRanges = ['15_24', '25_54', '55_64']
    with open(employment_by_age_table, mode='w') as file_to_write:
        fieldnames = ['countryCode', 'year','ageGroup', 'employmentByAgeRate']
        writer = csv.DictWriter(file_to_write, fieldnames=fieldnames)
        # writer.writeheader()
        for t in allLines:
            countryCode = t[0]
            year = t[1]
            ageGroup = t[2]
            employmentByAgeRate = allLines[t]
            writer.writerow({'countryCode': countryCode, 'year': year, 'ageGroup': ageGroup, 'employmentByAgeRate': employmentByAgeRate})

#*******************    EmploymentByEducation Table ******************#

def get_employment_by_education():
    allLines = {}
    educationRanges = {'TRY': 'POST_SECONDARY', 'UPPSRY_NTRY': 'UPPER_SECONDARY', 'BUPPSRY': 'LOWER_SECONDARY'}
    # reading employment_by_education values
    with open(employment_by_education, 'r', encoding='utf-8-sig') as file:
        csv_file = csv.DictReader(file)
        for row in csv_file:
            D = dict(row)
            location = D['LOCATION']
            year = D['TIME']
            if int(year) >= 2016 and int(year) <= 2019 and location not in special_groups:
                if (location, year, educationRanges[D['SUBJECT']])  not in allLines:
                    allLines[(location, year, educationRanges[D['SUBJECT']])] = D['Value']

    # writing to employment_by_education Table
    with open(employment_by_education_table, mode='w') as file_to_write:
        fieldnames = ['countryCode', 'year', 'educationLevel', 'employmentByEducationRate']
        writer = csv.DictWriter(file_to_write, fieldnames=fieldnames)
        # writer.writeheader()
        for t in allLines:
            countryCode = t[0]
            year = t[1]
            educationLevel = t[2]
            employmentByEducationRate = allLines[t]
            writer.writerow({'countryCode': countryCode, 'year': year, 'educationLevel': educationLevel, 'employmentByEducationRate': employmentByEducationRate})


#*******************    employment_by_enterprise Table ******************#

def get_employment_by_enterprise():
    allLines = {}

    # reading employment_by_enterprise values
    with open(employment_by_enterprise, 'r', encoding='utf-8-sig') as file:
        csv_file = csv.DictReader(file)
        for row in csv_file:
            D = dict(row)
            location = D['LOCATION']
            year = D['TIME']
            if int(year) >= 2016 and location not in special_groups:
                if (location, year, D['SUBJECT'])  not in allLines and D['Value'] != '':
                    allLines[(location, year, D['SUBJECT'])] = D['Value']
                else:
                    print("duplicate")

    # writing to employment_by_enterprise_table
    with open(employment_by_enterprise_table, mode='w') as file_to_write:
        fieldnames = ['countryCode', 'year', 'enterpriseSize', 'numEnterprises']
        writer = csv.DictWriter(file_to_write, fieldnames=fieldnames)

        # writer.writeheader()
        for t in allLines:
            countryCode = t[0]
            year = t[1]
            enterpriseSize = t[2]
            numEnterprises = allLines[t]
            writer.writerow({'countryCode': countryCode, 'year': year, 'enterpriseSize': enterpriseSize, 'numEnterprises': numEnterprises})


if __name__ == "__main__":
    # get_countries_gdp()
    # get_employment()
    get_employment_by_age()
    get_employment_by_education()
    # get_employment_by_enterprise()
