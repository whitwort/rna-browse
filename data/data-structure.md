# Database file layout

Save as .rds in `data/`:

```
list( name      = 'name'
    , notebook  = list(tabName1 = html, ...)
    , changes   = 'changes' # as markdown
    , tables    = list( list( name        = 'name'
                            , desc        = 'description'
                            , series      = list(Series1 = c('colName1', ...))
                            , annotations = c('colName1', ...)
                            , links       = list( colName = function(s) { url }
                                                , ...
                                                )
                            , data        = data.frame
                            )
                      , ...
                      )
    , requireGroup = c('groupname1', ...)
    )
```
