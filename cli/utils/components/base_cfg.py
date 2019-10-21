#!/usr/bin/env python3
import os
import json
import yaml

from abc import ABCMeta, abstractmethod
from argparse import ArgumentParser, Namespace


class BaseCfg(metaclass=ABCMeta):

    _root_path = os.path.join(
        os.path.dirname(os.path.realpath(__file__)),
        "../../.."
    )

    _pillar_path = os.path.join(
        _root_path,
        "pillar"
    )

    @abstractmethod
    def process_inputs(self, program_args: Namespace) -> bool:
        """Process CLI inputs.

        Args :
        arg_parser: Argument parser object as ArgumentParser
        """
        pass


    @abstractmethod
    def save(self):
        """ Save a Python dict into .sls file.

        Accepts no args and returns nothing. The file set on the component cfg object is used to save the data.
        """
        pass


    @abstractmethod
    def validate(self, schema_dict: dict, pillar_dict: dict) -> bool:
        """ Validate pillar dict against schema dict.

        This function validates the keys to be written to a pillar SLS file,
        as formed in the pillar_dict, against a standard reference schema_dict.

        Args :
        schema_dict : A reference dictionary object as a dict
        pillar_dict : A pillar dictionary object to be verified as a dict
        Returns :
        Validation results as bool
        """
        pass