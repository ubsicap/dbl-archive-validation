import json
from lxml import etree

from .metadata_as_json_exception import MetadataAsJsonException
from .root_atts import process_root_atts
from .dom_sections import *

class MetadataAsJson():
    """
    Class for converting between XML and JSON expressions of DBL Metadata.
    """
    
    xml_dom = None
    json_dict = None
    
    def __init__(self, xml_dom=None, xml_doc=None, json_dict=None, json_doc=None):

        def _init_from_dom():
            self.xml_dom = xml_dom
            self.json_dict = self.dict_from_dom()

        def _init_from_dict():
            self.json_dict = json_dict
            self.xml_dom = self.dom_from_dict()

        # Require exactly one data source
        sources = [s for s in [xml_dom, xml_doc, json_dict, json_doc] if s is not None]
        if len(sources) != 1:
            raise MetadataAsJsonException(
                {
                    "code": "ARGS-001",
                    "printable": "MetadataAsJson constructor requires exactly one data source"
                }
            )
        # Convert docs to data structures, then dispatch to source-specific helper functions
        if xml_doc is not None:
            xml_dom = etree.fromstring(xml_doc)
        if xml_dom is not None:
            _init_from_dom()
        else:
            if json_doc is not None:
                json_dict = json.loads(json_doc)
            _init_from_dict()

    def dict_from_dom(self):
        """
        Return a dictionary based on xml_dom
        """
        if self.xml_dom.tag != "DBLMetadata":
            raise MetadataAsJsonException(
                {
                    "code": "DOM-001",
                    "printable": "Expected DBLMetadata in DOM, found {0}".format(self.xml_dom.tag)
                }
            )
        ret = {}
        process_root_atts(self.xml_dom, ret)
        process_identification_section(self.xml_dom, ret)
        process_relationships_section(self.xml_dom, ret)
        process_agencies_section(self.xml_dom, ret)
        process_language_section(self.xml_dom, ret)
        process_countries_section(self.xml_dom, ret)
        process_type_section(self.xml_dom, ret)
        metadata_medium = None
        try:
            metadata_medium = ret["type"]["medium"]
        except:
            pass
        process_format_section(self.xml_dom, ret, metadata_medium)
        process_names_section(self.xml_dom, ret)
        # process_manifest_section(self.xml_dom, ret)
        # process_source_section(self.xml_dom, ret)
        # process_publications_section(self.xml_dom, ret)
        process_copyright_section(self.xml_dom, ret)
        process_promotion_section(self.xml_dom, ret)
        process_archive_status_section(self.xml_dom, ret)
        process_progress_section(self.xml_dom, ret)
        return ret

    def dom_from_dict(self):
        """
        Return dom based on json_dict
        """
        return etree.Element("DBLMetadata")
