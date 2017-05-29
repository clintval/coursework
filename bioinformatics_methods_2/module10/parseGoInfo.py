#!/usr/bin/env python3
import re
import itertools

__author__ = "clint valentine"


def split_obo_by_record(handle):
    """Group lines that have the seperator [Term] from an obo file handle. This
    method should be faster and less memory consumptive then loading in the
    entire file into RAM and using regex to parse breakpoints.

    Parameters
    ----------
    handle : io.TextIOWrapper
        File handle of an .obo file.

    Returns
    -------
    record_group : itertools.groupby
        A groupby object using `[Term]` as the seperator.

    """
    record_group = itertools.groupby(handle, lambda line: '[Term]' in line)
    return record_group


def split_go_record_group(group):
    """Parse a grouped GO term and return its individual attributes.

    Parameters:
    group : itertools.groupby
        A grouby object using `[Term]` as the seperator.

    Returns
    -------
    g_id : str
        The GO identifier.
    g_name : str
        The GO name.
    g_namespace : str
        The GO namespace.
    g_def : str
        The GO definition.
    g_synonym : str
        The GO synonym.
    is_a : list
        A list of all `is_a` attributes for the GO term.

`   """
    is_a = []

    # Initialize all values to None in case attributes are missing from record.
    g_id, g_name, g_namespace, g_def, g_synonym = None, None, None, None, None

    # Iterate through all lines in the group (skip those that are empty).
    for line in group:
        if line == '\n':
            continue

        # If we read into type definition records then we have completed a term
        # definition and can return all values.
        if line.strip() == '[Typedef]':
            return g_id, g_name, g_namespace, g_def, g_synonym, is_a

        # Split on first occurence of `:`, strip newline, and unpack.
        field, attribute = map(lambda line: line.strip(), line.split(':', 1))

        # Assign attribute to named variables, append if an `is_a` attribute.
        # This assignment would be quicker if string comparisons were used but
        # since the assignment requires regex parsing I have included it here.
        if re.match('^id$', field):
            g_id = attribute
        elif re.match('^name$', field):
            g_name = attribute
        elif re.match('^namespace$', field):
            g_namespace = attribute
        elif re.match('^def$', field):
            g_def = attribute
        elif re.match('^synonym$', field):
            g_synonym = attribute
        elif re.match('^is_a$', field):
            is_a.append(attribute)

    return g_id, g_name, g_namespace, g_def, g_synonym, is_a


if __name__ == '__main__':

    go_info = {}

    with open('/scratch/go-basic.obo') as handle:
        records = split_obo_by_record(handle)

        # Consume first entry as this contains the metadata of the file.
        header = next(records)

        # Iterate through boolean, line groups, if group is a seperator, skip.
        for key, group in records:
            if key:
                continue

            # Unpack all required variables for storing in go_info dictinoary.
            g_id, g_name, g_namespace, *_, is_a = split_go_record_group(group)

            # Format the value of the g_id with newlines and tabs.
            go_info[g_id] = '\n\t'.join([g_namespace,
                                         g_name,
                                         '\n\t'.join(is_a)])

    # Pretty print all records!
    for g_id, attributes in go_info.items():
        print('\t'.join([g_id, attributes]) + '\n')

