#!/usr/bin/env python3

import os
from lxml import etree


class DblValidatorException(Exception):
    pass


class DblValidator:
    schema = None
    schema_path = None

    def __init__(self):
        self.schema = {}
        self.schema_path = {}

    def add_schema(self, name, path):
        """
        Add the schema at *path* with *name* as the key
        """
        if name in self.schema:
            raise DblValidatorException(
                "Attempt to redefine schema '{0}' (previously loaded from {1} in add_schema()".format(name, self.schema_path[name])
            )
        self.schema_path[name] = path
        try:
            self.schema[name] = etree.RelaxNG(etree.parse(path))
        except Exception as exc:
            del(self.schema_path[name])
            raise DblValidatorException(
                "Error while attempting to parse schema '{0}' from '{1}' in add_schema(): {2}".format(name, path, exc)
            )

    def add_schemas(self, dir_path, ancestors = ""):
        """
        Recursively add schema in *dir_path*, generating a name based on the path to the schema
        """
        for item in os.listdir(dir_path):
            if os.path.isfile(os.path.join(dir_path, item)):
                filename_root, suffix = os.path.splitext(item)
                if suffix == ".rng":
                    self.add_schema(
                        ancestors + filename_root,
                        os.path.join(dir_path, item)
                    )
            elif os.path.isdir(os.path.join(dir_path, item)):
                self.add_schemas(
                    os.path.join(dir_path, item),
                    ancestors + item + "/"
                    )
                
    def validate_dom(self, schema_name, dom):
        """
        Validate dom against schema. Return a dictionary with

        * *well_formed* (True, since the dom exists)

        * *valid* (boolean)

        * *report* (string containing the schema error, if there's an error.)
        """
        if schema_name not in self.schema:
            raise DblValidatorException(
                "Attempt to validate using unknown schema '{0}' in validate_dom()".format(schema_name)
            )
        ret = {
            "well-formed": True
        }
        ret["valid"] = self.schema[schema_name].validate(dom)
        if not ret["valid"]:
            ret["report"] = str(self.schema[schema_name].error_log)
        return ret

    def validate_string(self, schema_name, xml_string):
        """
        Validate a string containing XML against schema. Return a dictionary with

        * *well_formed* (boolean)

        * *valid* (boolean)

        * *report* (string containing the dom or schema error, if there's an error.)
        """
        try:
            dom = etree.fromstring(xml_string)
        except Exception as exc:
            return {
                "well-formed": False,
                "valid": False,
                "report": str(exc)
            }
        return self.validate_dom(schema_name, dom)

    def validate_file(self, schema_name, path):
        """
        Validate a file at *path* containing XML against schema. Return a dictionary with

        * *well_formed* (boolean)

        * *valid* (boolean)

        * *report* (string containing the dom or schema error, if there's an error.)
        """
        if not os.path.isfile(path):
            raise DblValidatorException(
                "File {0} does not exist in validate_file()".format(os.path.abspath(path))
            )
        try:
            dom = etree.parse(path)
        except Exception as exc:
            return {
                "well-formed": False,
                "valid": False,
                "report": str(exc)
            }
        return self.validate_dom(schema_name, dom)
