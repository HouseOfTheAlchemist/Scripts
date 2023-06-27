input_file_csv = 'in.csv'
output_file_xls = 'out.xlsx'

# Install all these modules beforehand
import pandas
import requests
#import PTN
from guessit import guessit
import xlsxwriter

df = pandas.read_csv(input_file_csv)
dic = df.to_dict()

workbook = xlsxwriter.Workbook(output_file_xls)
worksheet = workbook.add_worksheet()

book_format = workbook.add_format()
book_format.set_bg_color('green')

for k, v in dic['Release Name'].items():
  worksheet.write(k, 0, v, )
  # parsed = PTN.parse(str(v))
  parsed = guessit(str(v))
  season = parsed.get('season', None);
  # print(parsed)
  season_string = ""
  # print(type(season))
  if season is not None and not isinstance(season, list):
    season_string += "S"
    if season < 10:
      season_string += "0"
    season_string += str(season)
  
  query = f"https://alchemist.itssoap.ninja/?search={parsed.get('title', '')}%20{season_string}%20{parsed.get('screen_size', '')}%20{parsed.get('release_group', '')}&json=1"
  # query.replace(' ', '%20')
  # print(query)
  # res = requests.get(f"https://alchemist.cyou/?search=%22{str(v)}%22&json=1")
  res = requests.get(query)
  try:
    results = res.json()['totalResults']
    if results > 1:
      worksheet.write(k, 0, v, book_format)
      worksheet.write(k, 1, "Alchemist")
  except:
    print(k, v)

workbook.close()