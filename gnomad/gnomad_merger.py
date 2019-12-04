#!/usr/bin/env python
# coding: utf-8
# Gokcumen Lab at UB

import os
import requests
import pandas as pd
import numpy as np

# Constants
FILE_GENE_LIST = "interested_genes.csv"
# directory names
DIR_DATA = "./data/"
DIR_OUTPUT = "./output/"
PATH_OUTPUT = DIR_OUTPUT + "genes_merged.csv"

# Global Variables
gene_id_list = []
saved_list = []


def fetch(jsondata, url="https://gnomad.broadinstitute.org/api"):
    '''
    The server gives a generic error message if the content type isn't
    explicitly set
    '''
    headers = {"Content-Type": "application/json"}
    response = requests.post(url, json=jsondata, headers=headers)
    json = response.json()
    if "errors" in json:
        raise Exception(json["errors"])
    return json


def get_variant_list(gene_id, dataset="gnomad_r2_1"):
    '''
    Interested columns for the final merged CSV file
    '''
    # Note that this is GraphQL, not JSON.
    fmt_graphql = """
    {
        gene(gene_name: "%s") {
            variants(dataset: %s) {
              chrom
              pos
              rsid
              ref
              alt
              consequence
              exome {
                ac
                ac_hemi
                ac_hom
                an
                af
                populations {
                  id
                  ac
                  an
                  ac_hemi
                  ac_hom
                }
              }
              genome {
                ac
                ac_hemi
                ac_hom
                an
                af
              }
              flags
              lof
              consequence_in_canonical_transcript
              gene_symbol
              hgvsc
              lof_filter
              lof_flags
              hgvsc
              hgvsp
              reference_genome
              variant_id: variantId
            }
        }
      }
    """
    # This part will be JSON encoded, but with the GraphQL part left as a
    # glob of text.
    req_variantlist = {
        "query": fmt_graphql % (gene_id, dataset),
        "variables": {}
    }
    response = fetch(req_variantlist)
    return response["data"]["gene"]["variants"]


# add the gene_id at the last column
def make_df(gene_id):
    li = get_variant_list(gene_id)
    df = pd.DataFrame(li)
    return df


# get_header
header = [
    'Name',
    'Chromosome',
    'Position',
    'rsID',
    'Reference',
    'Alternate',
    'Protein Consequence',
    'Transcript Consequence',
    'Annotation',
    'Flags',
    'Allele Count',
    'Allele Number',
    'Allele Frequency',
    'Homozygote Count',
    'Hemizygote Count',
    'Variant ID'
]


def create_new_df(old_df):
    df = old_df[old_df['exome'].notnull()]
    reframe_data = []
    for row in range(len(df)):
        newarray = []
        newarray.append(df.iloc[row].get('gene_symbol'))  # 1
        newarray.append(df.iloc[row].get('chrom'))  # 2
        newarray.append(df.iloc[row].get('pos'))  # 3
        newarray.append(df.iloc[row].get('rsid'))  # 4
        newarray.append(df.iloc[row].get('ref'))  # 5
        newarray.append(df.iloc[row].get('alt'))  # 6
        newarray.append(df.iloc[row].get('hgvsp'))  # 7
        newarray.append(df.iloc[row].get('hgvsc'))  # 8
        newarray.append(df.iloc[row].get('consequence'))  # 9
        if df.iloc[row].get('flags'): # 10
            newarray.append(df.iloc[row].get('flags')[0])
        else:
            newarray.append('')
        newarray.append(df.iloc[row].get('exome').get('ac'))  # 11
        newarray.append(df.iloc[row].get('exome').get('an'))  # 12
        newarray.append(df.iloc[row].get('exome').get('af'))  # 13
        newarray.append(df.iloc[row].get('exome').get('ac_hom'))  # 14
        newarray.append(df.iloc[row].get('exome').get('ac_hemi'))  # 15
        newarray.append(df.iloc[row].get('variant_id'))  # 16
        reframe_data.append(newarray)
    # add reframe_data and header
    new_df = pd.DataFrame(np.array(reframe_data), columns=header)
    return new_df


def generate_csv(gene_id_list):
    '''
    generate and download csv file of each gene, save to current path
    '''
    for gene_id in gene_id_list:
        try:
            gene_id = gene_id.strip()
            filepath = DIR_DATA + gene_id + '.csv'
            create_new_df(make_df(gene_id)).to_csv(filepath, index=False)
            saved_list.append(filepath)
            print('\x1b[6;30;42m' + 'Saved: ' + gene_id + '\x1b[0m')
        except:
            print('\x1b[6;30;41m' + 'Error: ' + gene_id + '\x1b[0m')
            pass


def merge_csv(gene_id_list):
    '''
    Download the merged csv file to current path, name as PATH_OUTPUT
    '''
    generate_csv(gene_id_list)
    combined_csv = pd.read_csv(saved_list[0])
    combined_csv.to_csv(PATH_OUTPUT, encoding="utf_8_sig", index=False)
    for gene_id in saved_list:
        combined_csv = pd.read_csv(gene_id)
        combined_csv.to_csv(PATH_OUTPUT, encoding="utf_8_sig",
                            index=False, header=False, mode='a+')
    print("Merging downloaded data to %s" % PATH_OUTPUT)


def initialize_dirs():
    '''
    Prepares the directories
    '''

    try:
        os.mkdir(DIR_DATA)
        os.mkdir(DIR_OUTPUT)
    except OSError:
        print ("Creation of the directory %s failed" % DIR_DATA)
        print ("Creation of the directory %s failed" % DIR_OUTPUT)
    else:
        print ("Successfully created the directory %s " % DIR_DATA)
        print ("Successfully created the directory %s " % DIR_OUTPUT)


if __name__ == '__main__':
    initialize_dirs()
    # Read interested genes
    df = pd.read_csv(FILE_GENE_LIST, delimiter=',')
    gene_id_list = df.columns.tolist()
    merge_csv(gene_id_list)
