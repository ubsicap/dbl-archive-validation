import os


from lxml import etree

def process_manifest_section(dom, json_dict):

    def _flatten(dom):
        xslt_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "flatten_manifest.xsl"))
        manifest_flattener = etree.XSLT(etree.parse(xslt_path))
        xslt_result = manifest_flattener(dom)
        return etree.fromstring(etree.tostring(xslt_result))

    manifest_sections = dom.xpath("manifest")
    if len(manifest_sections) > 0:
        manifest_section = _flatten(manifest_sections[0])
        json_dict["manifest"] = {}
        for resource_element in manifest_section.xpath("resource"):
            if "uri" in resource_element.attrib:
                resource_uri = str(resource_element.attrib["uri"])
                json_dict["manifest"][resource_uri] = {"uri": resource_uri}
                for string_att in [
                    "checksum",
                    "mimeType"
                ]:
                    if string_att in resource_element.attrib:
                        json_dict["manifest"][resource_uri][string_att] = str(resource_element.attrib[string_att])
                for int_att in [
                    "size",
                    "progress"
                ]:
                    if int_att in resource_element.attrib:
                        json_dict["manifest"][resource_uri][int_att] = int(resource_element.attrib[int_att])
