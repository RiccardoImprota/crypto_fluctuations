from database import UsersSQL

db=UsersSQL()
monete=db.get_coins_in_table()
print(monete)

for i in monete:
    print(i)
    db.bandaid(i)
