#!/usr/bin/python3


people = {1: {'name': 'John', 'age': '27', 'sex': 'Male'},
          2: {'name': 'Marie', 'age': '22', 'sex': 'Female'}}

people[3] = {}
people[4] = []
people[5] = {}

people[3]['name'] = 'Luna'
people[3]['age'] = '24'
people[3]['sex'] = 'Female'
people[3]['married'] = 'No'
exec('people[3]["ex"] = "Yes"')

people[4].append('No')
# {1: 'Yes', '1': {'9': 'No'}, '2': {1: {'9': 'No'}}}
exec('people[5][1] = "Yes"')
exec('people[5]["1"] = {}')
print("5 : " , type(people[5]["1"]))
exec('people[5]["1"] = "No"')
print("5 : " , type(people[5]["1"]))
try:
	exec('people[5]["1"]["9"] = "No"')
except TypeError as inst:
	print('Error')
	print(type(inst))    # the exception instance
	print(inst.args)     # arguments stored in .args
	print(inst)          # __str__ allows args to be printed directly,
	print('Error')
	# but may be overridden in exception subclasses
	#x, y = inst.args     # unpack args
	#print('x =', x)
	#print('y =', y)

exec('people[5]["2"] = {}')
exec('people[5]["2"][1] = {}')
exec('people[5]["2"][1]["9"] = "No"')

print("3 : " , type(people[3]))
print("3 : " , people[3])
print("4 : " , type(people[4]))
print("4 : " , people[4])
print("5 : " , type(people[5]))
print("5 : " , people[5])


# keyError exception handling : https://stackoverflow.com/questions/38188990/more-elegant-way-to-deal-with-multiple-keyerror-exceptions
# get value of nested dictionary : https://stackoverflow.com/questions/25833613/python-safe-method-to-get-value-of-nested-dictionary


exec(open("./DB4python.data").read())
print("D : " , type(D))
#print("D : " , D)
for k,v in D.items() :
    print(k);

def iter_paths(d):
    def iter1(d, path):
        paths = []
        for k, v in d.items():
            if isinstance(v, dict):
                paths += iter1(v, path + [k])
            paths.append((path + [k], v))
        return paths
    return iter1(d, [])

