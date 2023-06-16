input_file_csv = 'in.csv'
output_file_xls = 'out.xlsx'

# Install all these modules beforehand
import pandas
import requests
import PTN
import xlsxwriter

df = pandas.read_csv(input_file_csv)
dic = df.to_dict()

workbook = xlsxwriter.Workbook(output_file_xls)
worksheet = workbook.add_worksheet()

book_format = workbook.add_format()
book_format.set_bg_color('green')

for k, v in dic['Release Name'].items():
  worksheet.write(k, 0, v, )
  parsed = PTN.parse(str(v))
  # res = requests.get(f"https://alchemist.cyou/?search=%22{str(v)}%22&json=1")
  res = requests.get(f"https://alchemist.cyou/?search=%22{parsed.get('title', '')}%20{parsed.get('resolution', '')}%20{parsed.get('encoder', '')}%22&json=1")
  try:
    results = res.json()['totalResults']
    if results == 1:
      worksheet.write(k, 0, v, book_format)
      worksheet.write(k, 1, "Alchemist")
  except:
    print(k, v)

workbook.close()