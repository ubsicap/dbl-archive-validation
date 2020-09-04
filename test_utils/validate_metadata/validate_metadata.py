import argparse
import sys
import os
sys.path.append("../../..")
from dbl_dot_local.validator import DblValidator


def setup_arg_parser():
    ret = argparse.ArgumentParser(description="Command Line Interface to Validate Metadata")
    ret.add_argument("metadata_file", nargs="?", help="Path to a metadata.xml (By default validate all in Current Working Directory")
    ret.add_argument("--cwd", nargs="?", help="Current Working Directory")
    return ret


def check_args(parser):
    args = parser.parse_args()
    return args


if __name__ == "__main__":
    arg_parser = setup_arg_parser()
    args = check_args(arg_parser)
    print(args.metadata_file)
    if args.metadata_file and not os.path.exists(args.metadata_file):
        print("Invalid path to metadata.xml file: " + args.metadata_file)
        sys.exit(1)
    cwd = (args.cwd or os.getcwd()).replace("\\", "/")
    print("Current Working Directory: " + cwd)
    batch_metadata_file_path = args.metadata_file
    validator = DblValidator()
    schema_name = 'metadata.rng'
    schema_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "../..", "schema/dbl/2_2_1/metadata.rng"))
    print(schema_path)
    validator.add_schema(schema_name, schema_path)
    if batch_metadata_file_path:
        validation = validator.validate_file(schema_name, batch_metadata_file_path)
        print(validation)
        sys.exit(0)
    failures = []
    for path in os.listdir(cwd):
        if os.path.splitext(path)[1] != '.xml':
            continue
        print(path)
        full_path = os.path.join(cwd, path)
        validation = validator.validate_file(schema_name, full_path)
        if not validation["well-formed"] or not validation["valid"] or "report" in validation:
            print(validation)
            failures.append(validation)
    if len(failures) == 0:
        print("*****************************")
        print("** All validations passed! **")
        print("*****************************")
    else:
        print("***************************")
        print("** Validation Failures: **")
        print("***************************")
        print(failures)
