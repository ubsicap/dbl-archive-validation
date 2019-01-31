import json
import os
import pytest
import re


from lxml import etree


from ..metadata_as_json import MetadataAsJson
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
    ["dbl_test_text.xml", "dbl_test_audio.xml", "dbl_test_print.xml", "armenian_video.xml", "assamese_braille.xml"]
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
    assert len([a for a in maj.json_dict["agencies"].values() if a["type"] == "rightsHolder"]) > 0
    assert len([a for a in maj.json_dict["agencies"].values() if a["type"] == "contributor"]) > 0
    assert "iso" in maj.json_dict["language"]
    assert len(maj.json_dict["countries"]) > 0
    assert "iso" in list(maj.json_dict["countries"].values())[0]
    assert "isConfidential" in maj.json_dict["type"]
    assert type(maj.json_dict["type"]["hasCharacters"]) == bool
    assert len(maj.json_dict["manifest"]) > 0
    for resource in maj.json_dict["manifest"]:
        assert "uri" in maj.json_dict["manifest"][resource]
        assert "size" in maj.json_dict["manifest"][resource]
        assert type(maj.json_dict["manifest"][resource]["size"]) == int
    assert "fullStatement" in maj.json_dict["copyright"]
    assert "xhtml" in maj.json_dict["copyright"]["fullStatement"]
    assert len(maj.json_dict["copyright"]["fullStatement"]["xhtml"]) > 0
    assert "comments" in maj.json_dict["archiveStatus"]
    if "promoVersionInfo" in maj.json_dict["promotion"]:
        assert "contentType" in maj.json_dict["promotion"]["promoVersionInfo"]
        assert "content" in maj.json_dict["promotion"]["promoVersionInfo"]
        assert type(maj.json_dict["promotion"]["promoVersionInfo"]["content"]) == str
    if source in ["dbl_test_text.xml", "dbl_test_audio.xml"]:
        assert len(maj.json_dict["names"]) > 0
    if source in ["dbl_test_audio.xml", "dbl_test_print.xml"]:
        assert "relationships" in maj.json_dict
        for relation in maj.json_dict["relationships"].values():
            assert "type" in relation
    if source == "dbl_test_text.xml":
        assert "systemIds" in maj.json_dict["identification"]
        assert "versedParagraphs" in maj.json_dict["format"]
        assert type(maj.json_dict["format"]["versedParagraphs"]) == bool
        assert "MAT" in maj.json_dict["progress"]
        assert type(maj.json_dict["progress"]["MAT"]["stage"]) == int
    elif source == "dbl_test_audio.xml":
        assert "compression" in maj.json_dict["format"]
        assert type(maj.json_dict["format"]["compression"]) == str
        assert "bitRate" in maj.json_dict["format"]
        assert type(maj.json_dict["format"]["bitRate"]) == int
    elif source == "dbl_test_print.xml":
        assert "width" in maj.json_dict["format"]
        assert type(maj.json_dict["format"]["width"]) == str
        assert "pod" in maj.json_dict["format"]
        assert type(maj.json_dict["format"]["pod"]) == bool
        assert "pageCount" in maj.json_dict["format"]
        assert type(maj.json_dict["format"]["pageCount"]) == int
        assert len(maj.json_dict["format"]["fonts"]) > 0
        assert "type" in maj.json_dict["format"]["fonts"][0]
        assert "name" in maj.json_dict["format"]["fonts"][0]
        assert "top" in maj.json_dict["format"]["edgeSpace"]
        assert type(maj.json_dict["format"]["edgeSpace"]["top"]) == str
    elif source == "armenian_video.xml":
        assert "container" in maj.json_dict["format"]
        assert "codec" in maj.json_dict["format"]["videoStream"]
        assert type(maj.json_dict["format"]["videoStream"]["codec"]) == str
        assert "bitRate" in maj.json_dict["format"]["videoStream"]
        assert type(maj.json_dict["format"]["videoStream"]["bitRate"]) == int
        assert "frameRate" in maj.json_dict["format"]["videoStream"]
        assert type(maj.json_dict["format"]["videoStream"]["frameRate"]) == float
    elif source == "assamese_braille.xml":
        assert "isContracted" in maj.json_dict["format"]
        assert type(maj.json_dict["format"]["isContracted"]) == bool
        assert "version" in maj.json_dict["format"]["liblouis"]
        assert "source" in maj.json_dict["format"]["liblouis"]["table"]
        assert "src" in maj.json_dict["format"]["hyphenationDictionary"]
        assert "character" in maj.json_dict["format"]["numberSign"]
        assert "useInMargin" in maj.json_dict["format"]["numberSign"]
        assert type(maj.json_dict["format"]["numberSign"]["useInMargin"]) == bool
        assert "chapterNumberStyle" in maj.json_dict["format"]["content"]
        assert "charsPerLine" in maj.json_dict["format"]["page"]
        assert type(maj.json_dict["format"]["page"]["charsPerLine"]) == int
        assert "versoLastLineBlank" in maj.json_dict["format"]["page"]
        assert type(maj.json_dict["format"]["page"]["versoLastLineBlank"]) == bool

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
