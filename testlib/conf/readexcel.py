import xlrd#全部读取某条case所有的值存放在字典里面

class ExcelUtil():
    def __init__(self,filePath = "case.xls",sheetName="Sheet1"):
        self.excelPath=None
        self.data = xlrd.open_workbook(filePath)
        self.table = self.data.sheet_by_name(sheetName)
        # 获取第一行作为key值
        self.keys = self.table.row_values(0)
        # 获取总行数
        self.rowNum = self.table.nrows
        # 获取总列数
        self.colNum = self.table.ncols

    def dict_data(self):
        if self.rowNum <= 1:
            print("总行数小于1")
        else:
            r = []
            j = 1
            for i in list(range(self.rowNum-1)):
                s = {}
                # 从第二行取对应values值
                s['rowNum'] = i+2
                values = self.table.row_values(j)
                for x in list(range(self.colNum)):
                    s[self.keys[x]] = values[x]
                r.append(s)
                j += 1
            print(r)
            return r
if __name__ == "__main__":
    run=ExcelUtil()
    run.dict_data()

