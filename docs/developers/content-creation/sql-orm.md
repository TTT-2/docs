# SQL and ORM

A more advanced way of storing data if ConVars aren't enought anymore is a database. A database is like a table, with keys as columns and rows with data. The data can be read, modified and deleted. Additionally the database language SQL provides a powerful tool to get the required data without a big performance hit.

While GMod itself [provides a SQL library](https://wiki.facepunch.com/gmod/sql), TTT2 builds on top of that [with a SQL extension](https://api-docs.ttt2.neoxult.de/module/sql/none) and an [ORM system](https://api-docs.ttt2.neoxult.de/module/orm/none). The following article describes how to use the ORM system for an easy database usage without writing SQL code.

## Initializing a New Table

To get started, a table has to be initialized first. This is done like so:

```lua
local sqlTableName = "an_unique_table_name"
local savingKeys = {
    state = {typ = "bool", default = false},
    amount = {typ = "number", bits = 8, default = 0}
}

sql.CreateSqlTable(sqlTableName, savingKeys)
```

The function takes two arguments: The name of the table and the name (and type) of the data columns. The name of the table automatically creates the primary key column `name`.

???+ tip
    Check the return value from `sql.CreateSqlTable` to only proceed if the table was created. This might look like this:

    ```lua
    if not sql.CreateSqlTable(sqlTableName, savingKeys) then return end
    ```

## Creating an ORM Model

Once the table is initialized, an orm model can be created for this table. This can be done with a single line:

```lua
local ormModel = orm.Make(sqlTableName)
```

This function returns an orm model with which you can do many things.

## Using the ORM Model

All the following functions return an [ORM object](https://api-docs.ttt2.neoxult.de/class/ORMMODEL/none). An ORM object contains the data from the database and also the functions needed to modify the database directly. Keep this in mind when using those functions.

### Getting the Data Table

If you just want to get the whole table from the database as a lua table, you can do this by using the [`All()` function](https://api-docs.ttt2.neoxult.de/class/ORMMODEL/none/shared/ORMMODEL:All):

```lua
local data = ormModel:All()
```

This data table now is an indexed table with all entries from the database in form of an ORM object.

If you want specific data, then this function is probably not the right one for you. Itreating over the data in lua is significantly slower then directly accessing the wanted data in the database.

### Getting a Specific Entry

If you know the name of the row in the table, the [`Find()` function](https://api-docs.ttt2.neoxult.de/class/ORMMODEL/none/shared/ORMMODEL:Find) is the easiest way to retrieve the data:

```lua
local data = ormModel:Find(primaryValue)
```

This function either takes a single primary key or a table of primary keys and then returns a table of the found ORM objects.

### Finding Specific Matches

If you don't want a specific row, but a row where one or more columns match, the [`Where()`function](https://api-docs.ttt2.neoxult.de/class/ORMMODEL/none/shared/ORMMODEL:Where) is what you're looking for:

```lua
local data = ormModel:Where({
    {column = "state", value = true, concat = "AND"},
    {column = "amount", op = ">", value = 8}}
)
```

This function searches for all entries, where the `state` column is true and the `value` column is greater than 8. Then it returns a table of all found ORM objects.

### Creating a New Row

Adding new data is straighforward with the [`New()` function](https://api-docs.ttt2.neoxult.de/class/ORMMODEL/none/shared/ORMMODEL:New):

```lua
local data = ormModel:New({name = "primary_key", state = true, amount = 7})

data:Save()
```

This function returns a newly created orm object with the defined parameters. Keep in mind, that you always have to define the primary key `name`.

This newly created data is not yet saved in the database. This is done with the [`Save()` function](https://api-docs.ttt2.neoxult.de/class/ORMOBJECT/none/shared/ORMOBJECT:Save).

### Modifying Data

Once you know how to find data, you have to learn how to modify it. Mofifying data always consists out of three steps:

1. Get the ORM object of the data you want to modify
1. Modify the contents of the table
1. Save it to the database

Since we already discussed the first and the last step, the only thing to learn is step two. Luckily this step is really simple. All you have to do is to modify the table itself:

```lua
local data = ormModel:Find(primaryValue)

if not data then return end

data.state = false
data.amount = 12

data:Save()
```
