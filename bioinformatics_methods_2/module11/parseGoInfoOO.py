#!/usr/bin/env python3
import re

__author__ = 'clint valentine'


class goTerm(object):
    def __init__(self, record):
        # Bind empty variables to None or empty list.
        self.id, self.name, self.namespace = None, None, None
        self.is_a = []

        # is_a items are repeated so need a specific pattern to capture them.
        is_a_pattern = re.compile('is_a:\s*(.*?)\n')

        # name items appear once in order so can capture these in one pattern.
        name_pattern = re.compile(
            'id:\s*(GO.*?)\n.*?name:\s*(.*?)\n.*?namespace:\s*(.*?)\n',
            re.DOTALL
        )

        # Perform the search on name patterns.
        names = re.search(name_pattern, record)

        # Typedef records do not match this name pattern so do not instantiate
        # attributes for ths object.
        if names is not None and len(names.groups()) == 3:
            # Safe to unpack all variables from captured name groups.
            self.id, self.name, self.namespace = names.groups()

            # Find all is_a items if they exist.
            self.is_a = re.findall(is_a_pattern, record)

    def printAll(self):
        return self.__repr__()

    def __repr__(self):
        canon = '\n'.join([
            '{}\t{}\n\t{}'.format(self.id, self.namespace, self.name),
            '\n'.join(['\t{}'.format(is_a) for is_a in self.is_a])]
        )
        return canon


if __name__ == '__main__':
    infile = '/scratch/go-basic.obo'

    go_terms = {}

    # Use a non-capturing negative lookbehind with a non-capturing
    # alternation of either Term or Typedef fields. Compile pattern for
    # speed. Note: we will need to detect Typedef entries later.
    re_delimiter = re.compile('(?<!:)(?:\[Term\]|\[Typedef\])')

    with open(infile) as handle:
        # Split the entire file on the compiled regex pattern.
        records = re.split(re_delimiter, handle.read())

        # Iterate through all records except the initial metadata record.
        for record in records[1:]:
            go = goTerm(record)
            go_terms[go.id] = go

    for go_id in go_terms:
        print(go_terms[go_id].printAll(), '\n')
