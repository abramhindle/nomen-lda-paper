import    plot_timeline as pt


mysql_data = {'2004-04-11': {'none': 0, 'portability': 0, 'efficiency': 0, 'reliability': 2, 'functionality': 4, 'maintainability': 0, 'usability': 0}, '2001-04-27': {'none': 1, 'portability': 40, 'efficiency': 2, 'reliability': 13, 'functionality': 23, 'maintainability': 24, 'usability': 0}, '2000-07-31': {'none': 3, 'portability': 40, 'efficiency': 2, 'reliability': 7, 'functionality': 54, 'maintainability': 48, 'usability': 0}, '2001-06-26': {'none': 5, 'portability': 16, 'efficiency': 7, 'reliability': 8, 'functionality': 14, 'maintainability': 17, 'usability': 0}, '2001-01-27': {'none': 3, 'portability': 36, 'efficiency': 0, 'reliability': 19, 'functionality': 22, 'maintainability': 18, 'usability': 7}, '2003-11-13': {'none': 0, 'portability': 7, 'efficiency': 0, 'reliability': 0, 'functionality': 0, 'maintainability': 0, 'usability': 0}, '2003-03-18': {'none': 1, 'portability': 4, 'efficiency': 0, 'reliability': 0, 'functionality': 10, 'maintainability': 0, 'usability': 3}, '2001-09-24': {'none': 0, 'portability': 21, 'efficiency': 0, 'reliability': 0, 'functionality': 10, 'maintainability': 9, 'usability': 3}, '2003-04-17': {'none': 1, 'portability': 1, 'efficiency': 0, 'reliability': 3, 'functionality': 17, 'maintainability': 4, 'usability': 0}, '2004-05-11': {'none': 0, 'portability': 0, 'efficiency': 0, 'reliability': 0, 'functionality': 6, 'maintainability': 0, 'usability': 0}, '2003-02-16': {'none': 1, 'portability': 3, 'efficiency': 0, 'reliability': 7, 'functionality': 25, 'maintainability': 14, 'usability': 2}, '2004-08-09': {'none': 0, 'portability': 0, 'efficiency': 0, 'reliability': 4, 'functionality': 2, 'maintainability': 2, 'usability': 0}, '2000-10-29': {'none': 1, 'portability': 36, 'efficiency': 0, 'reliability': 21, 'functionality': 35, 'maintainability': 14, 'usability': 4}, '2004-03-12': {'none': 0, 'portability': 0, 'efficiency': 0, 'reliability': 0, 'functionality': 2, 'maintainability': 4, 'usability': 0}, '2002-02-21': {'none': 4, 'portability': 9, 'efficiency': 0, 'reliability': 2, 'functionality': 8, 'maintainability': 9, 'usability': 0}, '2001-07-26': {'none': 1, 'portability': 27, 'efficiency': 2, 'reliability': 18, 'functionality': 19, 'maintainability': 14, 'usability': 3}, '2003-08-15': {'none': 0, 'portability': 2, 'efficiency': 0, 'reliability': 4, 'functionality': 12, 'maintainability': 2, 'usability': 0}, '2002-05-22': {'none': 0, 'portability': 5, 'efficiency': 0, 'reliability': 0, 'functionality': 16, 'maintainability': 9, 'usability': 0}, '2002-12-18': {'none': 0, 'portability': 3, 'efficiency': 4, 'reliability': 5, 'functionality': 24, 'maintainability': 7, 'usability': 0}, '2003-05-17': {'none': 1, 'portability': 4, 'efficiency': 2, 'reliability': 4, 'functionality': 21, 'maintainability': 0, 'usability': 0}, '2001-11-23': {'none': 2, 'portability': 6, 'efficiency': 12, 'reliability': 12, 'functionality': 10, 'maintainability': 19, 'usability': 0}, '2001-05-27': {'none': 2, 'portability': 22, 'efficiency': 9, 'reliability': 27, 'functionality': 27, 'maintainability': 18, 'usability': 8}, '2003-10-14': {'none': 0, 'portability': 0, 'efficiency': 0, 'reliability': 0, 'functionality': 4, 'maintainability': 1, 'usability': 7}, '2001-10-24': {'none': 1, 'portability': 17, 'efficiency': 6, 'reliability': 4, 'functionality': 20, 'maintainability': 20, 'usability': 0}, '2002-07-21': {'none': 1, 'portability': 35, 'efficiency': 4, 'reliability': 2, 'functionality': 44, 'maintainability': 14, 'usability': 3}, '2002-09-19': {'none': 2, 'portability': 16, 'efficiency': 4, 'reliability': 0, 'functionality': 26, 'maintainability': 14, 'usability': 0}, '2002-08-20': {'none': 1, 'portability': 10, 'efficiency': 10, 'reliability': 6, 'functionality': 14, 'maintainability': 11, 'usability': 3}, '2000-08-30': {'none': 1, 'portability': 27, 'efficiency': 0, 'reliability': 2, 'functionality': 31, 'maintainability': 34, 'usability': 5}, '2002-10-19': {'none': 3, 'portability': 8, 'efficiency': 0, 'reliability': 14, 'functionality': 20, 'maintainability': 9, 'usability': 0}, '2001-12-23': {'none': 0, 'portability': 12, 'efficiency': 2, 'reliability': 10, 'functionality': 10, 'maintainability': 5, 'usability': 0}, '2003-06-16': {'none': 0, 'portability': 0, 'efficiency': 4, 'reliability': 2, 'functionality': 12, 'maintainability': 0, 'usability': 0}, '2003-09-14': {'none': 1, 'portability': 3, 'efficiency': 0, 'reliability': 0, 'functionality': 6, 'maintainability': 4, 'usability': 0}, '2004-01-12': {'none': 1, 'portability': 2, 'efficiency': 0, 'reliability': 0, 'functionality': 4, 'maintainability': 0, 'usability': 0}, '2004-02-11': {'none': 0, 'portability': 0, 'efficiency': 0, 'reliability': 0, 'functionality': 4, 'maintainability': 0, 'usability': 0}, '2004-06-10': {'none': 2, 'portability': 0, 'efficiency': 0, 'reliability': 0, 'functionality': 4, 'maintainability': 0, 'usability': 0}, '2004-07-10': {'none': 0, 'portability': 3, 'efficiency': 0, 'reliability': 0, 'functionality': 0, 'maintainability': 1, 'usability': 0}, '2002-06-21': {'none': 0, 'portability': 6, 'efficiency': 2, 'reliability': 6, 'functionality': 27, 'maintainability': 6, 'usability': 5}, '2001-08-25': {'none': 0, 'portability': 32, 'efficiency': 4, 'reliability': 7, 'functionality': 19, 'maintainability': 14, 'usability': 0}, '2000-09-29': {'none': 1, 'portability': 26, 'efficiency': 7, 'reliability': 2, 'functionality': 21, 'maintainability': 20, 'usability': 6}, '2002-03-23': {'none': 0, 'portability': 20, 'efficiency': 6, 'reliability': 0, 'functionality': 32, 'maintainability': 6, 'usability': 0}, '2002-11-18': {'none': 1, 'portability': 12, 'efficiency': 0, 'reliability': 5, 'functionality': 29, 'maintainability': 13, 'usability': 4}, '2003-01-17': {'none': 1, 'portability': 9, 'efficiency': 0, 'reliability': 20, 'functionality': 32, 'maintainability': 3, 'usability': 0}, '2002-04-22': {'none': 2, 'portability': 16, 'efficiency': 0, 'reliability': 8, 'functionality': 26, 'maintainability': 9, 'usability': 0}, '2000-11-28': {'none': 1, 'portability': 35, 'efficiency': 5, 'reliability': 20, 'functionality': 42, 'maintainability': 33, 'usability': 13}, '2002-01-22': {'none': 1, 'portability': 6, 'efficiency': 19, 'reliability': 12, 'functionality': 18, 'maintainability': 10, 'usability': 3}, '2001-03-28': {'none': 0, 'portability': 45, 'efficiency': 3, 'reliability': 22, 'functionality': 46, 'maintainability': 29, 'usability': 11}, '2003-12-13': {'none': 0, 'portability': 0, 'efficiency': 0, 'reliability': 0, 'functionality': 0, 'maintainability': 0, 'usability': 0}, '2003-07-16': {'none': 0, 'portability': 0, 'efficiency': 0, 'reliability': 2, 'functionality': 4, 'maintainability': 2, 'usability': 0}, '2001-02-26': {'none': 0, 'portability': 46, 'efficiency': 10, 'reliability': 13, 'functionality': 35, 'maintainability': 27, 'usability': 6}, '2000-12-28': {'none': 2, 'portability': 28, 'efficiency': 8, 'reliability': 26, 'functionality': 17, 'maintainability': 27, 'usability': 9}}

max_db_data = {'2004-08-28': {'none': 3, 'portability': 8, 'efficiency': 3, 'reliability': 1, 'functionality': 3, 'maintainability': 5, 'usability': 7}, '2004-11-26': {'none': 7, 'portability': 9, 'efficiency': 2, 'reliability': 0, 'functionality': 1, 'maintainability': 7, 'usability': 2}, '2006-05-20': {'none': 13, 'portability': 2, 'efficiency': 4, 'reliability': 1, 'functionality': 0, 'maintainability': 2, 'usability': 2}, '2005-11-21': {'none': 15, 'portability': 2, 'efficiency': 0, 'reliability': 1, 'functionality': 1, 'maintainability': 1, 'usability': 0}, '2004-09-27': {'none': 8, 'portability': 10, 'efficiency': 0, 'reliability': 2, 'functionality': 2, 'maintainability': 6, 'usability': 0}, '2006-01-20': {'none': 13, 'portability': 3, 'efficiency': 1, 'reliability': 1, 'functionality': 3, 'maintainability': 2, 'usability': 0}, '2005-12-21': {'none': 11, 'portability': 2, 'efficiency': 2, 'reliability': 1, 'functionality': 2, 'maintainability': 6, 'usability': 0}, '2005-08-23': {'none': 10, 'portability': 3, 'efficiency': 0, 'reliability': 5, 'functionality': 0, 'maintainability': 4, 'usability': 4}, '2006-04-20': {'none': 7, 'portability': 1, 'efficiency': 7, 'reliability': 1, 'functionality': 1, 'maintainability': 6, 'usability': 0}, '2004-07-29': {'none': 8, 'portability': 3, 'efficiency': 1, 'reliability': 2, 'functionality': 2, 'maintainability': 3, 'usability': 0}, '2004-10-27': {'none': 7, 'portability': 7, 'efficiency': 3, 'reliability': 2, 'functionality': 3, 'maintainability': 6, 'usability': 2}, '2005-01-25': {'none': 10, 'portability': 4, 'efficiency': 3, 'reliability': 0, 'functionality': 0, 'maintainability': 4, 'usability': 1}, '2005-07-24': {'none': 8, 'portability': 4, 'efficiency': 3, 'reliability': 1, 'functionality': 0, 'maintainability': 3, 'usability': 1}, '2004-12-26': {'none': 6, 'portability': 15, 'efficiency': 3, 'reliability': 2, 'functionality': 2, 'maintainability': 3, 'usability': 2}, '2006-03-21': {'none': 8, 'portability': 3, 'efficiency': 6, 'reliability': 0, 'functionality': 3, 'maintainability': 2, 'usability': 0}, '2005-06-24': {'none': 2, 'portability': 10, 'efficiency': 8, 'reliability': 5, 'functionality': 2, 'maintainability': 7, 'usability': 0}, '2006-02-19': {'none': 11, 'portability': 0, 'efficiency': 1, 'reliability': 0, 'functionality': 1, 'maintainability': 7, 'usability': 0}, '2006-06-19': {'none': 7, 'portability': 4, 'efficiency': 2, 'reliability': 1, 'functionality': 3, 'maintainability': 0, 'usability': 1}, '2005-10-22': {'none': 13, 'portability': 1, 'efficiency': 1, 'reliability': 1, 'functionality': 1, 'maintainability': 3, 'usability': 0}, '2004-06-29': {'none': 1, 'portability': 28, 'efficiency': 11, 'reliability': 42, 'functionality': 18, 'maintainability': 20, 'usability': 10}}
    
pt.plot_timeline('mysql',mysql_data)