import re
from lxml import etree

from .xhtml import xhtml2string

def process_copyright_section(dom, json_dict):
    copyright_sections = dom.xpath("copyright")
    if len(copyright_sections) > 0:
        copyright_section = copyright_sections[0]
        json_dict["copyright"] = {}
        for statement in ["fullStatement", "shortStatement"]:
            statement_elements = copyright_section.xpath(statement)
            if len(statement_elements) > 0:
                statement_element = statement_elements[0]
                json_dict["copyright"][statement] = {}
                for statement_content_element in statement_element.xpath("statementContent"):
                    try:
                        statement_type = statement_content_element.attrib["type"]
                    except:
                        continue
                    json_dict["copyright"][statement][statement_type] = xhtml2string(statement_content_element)
