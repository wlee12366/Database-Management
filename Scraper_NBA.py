from urllib.request import urlopen
from bs4 import BeautifulSoup
import pandas as pd

url_template = "http://www.basketball-reference.com/draft/NBA_{year}.html"

# Declare dataframe
draft_df = pd.DataFrame()

# Loop for all years.Note: Can go back to 1950.
for year in range(2009, 2019):
    url = url_template.format(year = year)
    
    # Retrieve url
    html = urlopen(url) 
    # Create Beautiful Soup object
    soup = BeautifulSoup(html, 'html5lib') 
    
    # Grab column headers from website
    column_headers = [th.getText() for th in soup.findAll('tr', limit=2)[1].findAll('th')]
    
    # Grab NBA career stat for drafted player
    data_rows = soup.findAll('tr')[2:] 
    player_data = [[td.getText() for td in data_rows[i].findAll('td')]
                for i in range(len(data_rows))]
    
    # Seasonal data df
    year_df = pd.DataFrame(player_data, columns=column_headers[1:])
    
    # Create year drafted column
    year_df.insert(0, 'Draft_Yr', year)
    
    # Append to main df
    draft_df = draft_df.append(year_df, ignore_index=True)
    

# Convert data to proper data types
draft_df = draft_df.convert_objects(convert_numeric=True)

# Get rid of the rows full of null values
draft_df = draft_df[draft_df.Player.notnull()]

# Replace NaNs with 0s
draft_df = draft_df.fillna(0)

# Rename Columns
draft_df.rename(columns={'WS/48':'WS_per_48'}, inplace=True)

# Change % symbol to _Perc
draft_df.columns = draft_df.columns.str.replace('%', '_Perc')

# Add per_G to per game stats
draft_df.columns.values[15:19] = [draft_df.columns.values[15:19][col] + "_per_G" for col in range(4)]

# Change data type to int
draft_df.loc[:,'Yrs':'AST'] = draft_df.loc[:,'Yrs':'AST'].astype(int)

# Change draft pick to integer
draft_df['Pk'] = draft_df['Pk'].astype(int) 

draft_df.to_csv("draft_data_2009_to_2018.csv")