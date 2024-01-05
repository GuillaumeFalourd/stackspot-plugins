from templateframework.metadata import Metadata
from questionary import questionary
import re


def run(metadata: Metadata = None):
    request_project_name(metadata)
    request_project_artifact_id(metadata)
    request_project_group_id(metadata)
    request_java_version(metadata)
    request_build_tool(metadata)
    request_package_dir(metadata)


def request_project_name(metadata):
    if "project_name" not in metadata.global_inputs:
        project_name = questionary.text(message="Inform the project name",
                                        validate=validate_project_name).unsafe_ask()
        metadata.global_inputs["project_name"] = project_name


def request_project_artifact_id(metadata):
    if "project_artifact_id" not in metadata.global_inputs:
        project_artifact_id = questionary.text(message="Inform the project artifact ID",
                                               validate=validate_project_artifact_id).unsafe_ask()
        metadata.global_inputs["project_artifact_id"] = project_artifact_id


def request_project_group_id(metadata):
    if "project_group_id" not in metadata.global_inputs:
        project_group_id = questionary.text(message="Enter the base package for the project",
                                            instruction="(E.g: br.com.org)",
                                            validate=validate_java_package_name).unsafe_ask()
        metadata.global_inputs["project_group_id"] = project_group_id


def request_spring_boot_version(metadata):
    if "spring_boot_version" not in metadata.global_inputs:
        spring_boot_version = questionary.select("Select spring boot version", choices=["2.7.2", "3.0.1"]).unsafe_ask()
        metadata.global_inputs["spring_boot_version"] = spring_boot_version


def request_java_version(metadata):
    if "project_java_version" not in metadata.global_inputs:
        available_java_versions = ["17"]
        if metadata.global_inputs["spring_boot_version"] < '3':
            available_java_versions.append("11")
            available_java_versions.append("8")

        project_java_version = questionary.select("Select the Java version",
                                                  choices=available_java_versions).unsafe_ask()
        metadata.global_inputs["project_java_version"] = project_java_version


def request_build_tool(metadata):
    if "build_tool" not in metadata.global_inputs:
        build_tool = questionary.select("Select the project build tool", choices=["Gradle", "Maven"]).unsafe_ask()
        metadata.global_inputs["build_tool"] = build_tool


def request_package_dir(metadata):
    if "package_dir" not in metadata.global_computed_inputs:
        replaced_project_name = metadata.global_inputs["project_name"].replace('-', '')
        project_group_id = metadata.global_inputs["project_group_id"]
        metadata.global_computed_inputs["package_dir"] = f"{project_group_id}.{replaced_project_name}".replace('.', '/')
        metadata.global_computed_inputs["base_package"] = f"{project_group_id}.{replaced_project_name}"


def validate_java_package_name(value):
    if re.search("(^[a-zA-Z_\d.]*[a-zA-Z_\d]$)", value) is None:
        return "Invalid package name: Follow the java package naming convention " \
               "https://docs.oracle.com/javase/tutorial/java/package/namingpkgs.html "
    else:
        return True


def validate_project_name(value):
    if re.search("(^[\w\d-]+$)", value) is None:
        return "Invalid project name."
    return True


def validate_project_artifact_id(value):
    if re.search("(^[a-zA-Z-_\d]*$)", value) is None:
        return "Invalid artifact id."
    return True
