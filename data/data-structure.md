# Database file layout

Save as .rds in `data/`:

```
list( name      = character(1)
    , notebook  = list(tabName1 = html, ...)
    , changes   = character
    , tables    = list( list( name        = character(1)
                            , desc        = character(1)
                            , series      = list(Series1 = c('colName1', ...))
                            , annotations = c('colName1', ...)
                            , links       = list( colName = function(s) { url }
                                                , ...
                                                )
                            , data        = data.frame
                            )
                      , ...
                      )
    )
```
