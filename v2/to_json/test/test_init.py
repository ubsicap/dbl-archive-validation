import json
import os
import pytest
import re


from lxml import etree


from ..metadata_to_json import MetadataAsJson
from ..metadata_as_json_exception import MetadataAsJsonException

def _no_exception_surprises(exc, code, printable_regex):
    assert _exception_surprises(exc, code, printable_regex) is None

def _exception_surprises(exc, code, printable_regex):
    """
    Returns None if the exception has the correct code and matches the regex.
    In other cases it returns a diagnostic string.
    """
    exception_dict = exc.value.args[0]
    if code != exception_dict["code"]:
        return "Expected code {0}, found {1}".format(code, exception_dict["code"])
    if not re.search(printable_regex, exception_dict["printable"]):
        return "No match for '{0}' in '{1}'".format(printable_regex, exception_dict["printable"])

def _test_data_dir():
    return os.path.abspath(os.path.join(os.path.dirname(__file__), "test_data"))

def test_no_source_fail():
    """
    Init should fail if no source provided.
    """
    with pytest.raises(MetadataAsJsonException) as exc:
        MetadataAsJson()
    _no_exception_surprises(exc, "ARGS-001", "exactly one")

def test_multiple_source_fail():
    """
    Init should fail if multiple sources provided.
    """
    with pytest.raises(MetadataAsJsonException) as exc:
        MetadataAsJson(xml_doc="<foo/>", xml_dom=etree.fromstring("<foo/>"))
    _no_exception_surprises(exc, "ARGS-001", "exactly one")
    with pytest.raises(MetadataAsJsonException) as exc:
        MetadataAsJson(json_doc="{'foo': 'baa'}", json_dict={"foo": "baa"})
    _no_exception_surprises(exc, "ARGS-001", "exactly one")

def test_bad_root_tag_fail():
    """
    Init should fail if the provided DOM does not have DBLMetadata as the root element.
    """
    with pytest.raises(MetadataAsJsonException) as exc:
        MetadataAsJson(xml_doc="<foo/>")
    _no_exception_surprises(exc, "DOM-001", "DBLMetadata.*foo")

@pytest.mark.parametrize(
    'source',
    ["text.xml", "audio.xml", "video.xml", "print.xml", "braille.xml"]
)
def test_template_xml_init(source):
    """
    Init should work with DBL.Local XML templates (which are not valid and extremely incomplete).
    """
    fq_source = os.path.join(_test_data_dir(), "xml", "template_metadata", source)
    with open(fq_source, "rb") as xml_in:
        doc = xml_in.read()
    maj = MetadataAsJson(xml_doc=doc)
    dom = etree.fromstring(doc)
    maj = MetadataAsJson(xml_dom=dom)
    assert type(maj.json_dict["version"]) == float

@pytest.mark.parametrize(
    'source',
    ["dbl_test_text.xml", "dbl_test_audio.xml", "dbl_test_print.xml"]
)
def test_complete_xml_init(source):
    """
    Init should work with valid metadata.
    """
    fq_source = os.path.join(_test_data_dir(), "xml", "complete_metadata", source)
    with open(fq_source, "rb") as xml_in:
        doc = xml_in.read()
    maj = MetadataAsJson(xml_doc=doc)
    dom = etree.fromstring(doc)
    maj = MetadataAsJson(xml_dom=dom)
    assert type(maj.json_dict["version"]) == float
    assert "name" in maj.json_dict["identification"]
    if source == "dbl_text_text.xml":
        assert "systemIds" in maj.json_dict["identification"]
    if source in ["dbl_test_audio.xml", "dbl_test_print.xml"]:
        assert "relationships" in maj.json_dict
        for relation in maj.json_dict["relationships"].values():
            assert "type" in relation

@pytest.mark.parametrize(
    'source',
    ["stub.json"]
)
def test_template_json_init(source):
    """
    Init should work with the JSON expression of DBL.Local XML templates (which are not valid and extremely incomplete).
    """
    fq_source = os.path.join(_test_data_dir(), "json", "template_metadata", source)
    with open(fq_source, "rb") as json_in:
        doc = json_in.read()
    maj = MetadataAsJson(json_doc=doc)
    json_dict = json.loads(doc)
    maj = MetadataAsJson(json_dict=json_dict)
