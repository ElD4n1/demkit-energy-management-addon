from requirementslib import Pipfile

pf = Pipfile.load('Pipfile')
with open('requirements.txt', 'w') as f:
    for req in pf.requirements:
        f.write(f"{req.as_line()}\n")
