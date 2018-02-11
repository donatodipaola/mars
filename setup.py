# -*- coding: utf-8 -*-

from setuptools import setup, find_packages


with open('README.md') as f:
    readme = f.read()

with open('LICENSE') as f:
    license = f.read()

setup(
    name='mars',
    version='1.0.0',
    description='A simulator for multi agent robotic systems',
    long_description=readme,
    author='Donato Di Paola',
    author_email='donatodipaola@gmail.com',
    url='https://gitlab.com/donatodipaola/mars',
    license=license,
    packages=find_packages(exclude=('test'))
)
