#!/usr/bin/env python
# coding: utf-8
# Gokcumen Lab at UB

import os
import requests
import pandas as pd
import numpy as np
import json
# Constants
FILE_GENE_LIST = "interested_genes.csv"
# directory names
DIR_DATA = "./data/"
DIR_OUTPUT = "./output/"
PATH_VARIANT_OUTPUT_FILE = DIR_OUTPUT + "genes_merged.csv"
PATH_CONSTRAINTS_OUTPUT_FILE = DIR_OUTPUT + "constraints_merged.csv"

# Interested Columns
HEADER_VARIANTS = [
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
    'Variant ID',
    'Allele Count AFR',
    'Allele Number AFR',
    'Homozygote Count AFR',
    'Hemizygote Count AFR',
    'Allele Count AMR',
    'Allele Number AMR',
    'Homozygote Count AMR',
    'Hemizygote Count AMR',
    'Allele Count ASJ',
    'Allele Number ASJ',
    'Homozygote Count ASJ',
    'Hemizygote Count ASJ',
    'Allele Count EAS',
    'Allele Number EAS',
    'Homozygote Count EAS',
    'Hemizygote Count EAS',
    'Allele Count FIN',
    'Allele Number FIN',
    'Homozygote Count FIN',
    'Hemizygote Count FIN',
    'Allele Count NFE',
    'Allele Number NFE',
    'Homozygote Count NFE',
    'Hemizygote Count NFE',
    'Allele Count OTH',
    'Allele Number OTH',
    'Homozygote Count OTH',
    'Hemizygote Count OTH',
    'Allele Count SAS',
    'Allele Number SAS',
    'Homozygote Count SAS',
    'Hemizygote Count SAS'
]

HEADER_CONSTRAINTS = [
    'gene_name',
    'exp_lof',
    'exp_mis',
    'exp_syn',
    'obs_lof',
    'obs_mis',
    'obs_syn',
    'oe_lof',
    'oe_mis',
    'oe_syn',
    'lof_z',
    'mis_z',
    'syn_z',
    'pLI',
    'flags'
]


# Global Variables
gene_id_list = []
saved_list = []
constraints_list = []


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


def generate_variants_df(gene_id):
    '''
    Creates a dataframe of variants with respect to the given gene_id
    '''
    li = get_variant_list(gene_id)
    df = pd.DataFrame(li)
    return df


def reframe_variants(variant_df):
    '''
    Reframes the fetched data
    '''
    df = variant_df[variant_df['exome'].notnull()]
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
        if df.iloc[row].get('flags'):  # 10
            newarray.append(df.iloc[row].get('flags')[0])
        else:
            newarray.append('')
        newarray.append(df.iloc[row].get('exome').get('ac'))  # 11
        newarray.append(df.iloc[row].get('exome').get('an'))  # 12
        newarray.append(df.iloc[row].get('exome').get('af'))  # 13
        newarray.append(df.iloc[row].get('exome').get('ac_hom'))  # 14
        newarray.append(df.iloc[row].get('exome').get('ac_hemi'))  # 15
        newarray.append(df.iloc[row].get('variant_id'))  # 16
        # populations
        popList = df.iloc[row].get('exome').get('populations', None)
        if popList:
            for item in popList:
                # print(item)
                newarray.append(item['ac'])  # 'Allele Count'
                newarray.append(item['an'])  # 'Allele Number'
                newarray.append(item['ac_hom'])  # 'Homozygote Count'
                newarray.append(item['ac_hemi'])  # 'Hemizygote Number'

        reframe_data.append(newarray)
    # add reframe_data and header
    new_df = pd.DataFrame(np.array(reframe_data), columns=HEADER_VARIANTS)
    return new_df


def fetch_constraints_by_gene_id(gene_id):
    '''
    Interested columns for the constraint merged CSV file
    '''
    # Note that this is GraphQL, not JSON.
    fmt_graphql = """
    {
        gene(gene_name: "%s") {
            gene_name
            gnomad_constraint {
                exp_lof
                exp_mis
                exp_syn
                obs_lof
                obs_mis
                obs_syn
                oe_lof
                oe_mis
                oe_syn
                lof_z
                mis_z
                syn_z
                pLI
                flags
            }
      }
    }
    """
    # This part will be JSON encoded, but with the GraphQL part left as a
    # glob of text.
    req_constraint_list = {
        "query": fmt_graphql % (gene_id),
        "variables": {}
    }
    response = fetch(req_constraint_list)
    # include gene_name
    response["data"]["gene"]["gnomad_constraint"]["gene_name"] = response["data"]["gene"]["gene_name"]
    #print(json.dumps(response, indent=2))
    return response["data"]["gene"]["gnomad_constraint"]

def generate_csv_files(gene_id_list):
    '''
    generate and download csv file of each gene, save to the current path
    '''
    for gene_id in gene_id_list:
        try:
            gene_id = gene_id.strip()
            # variants
            filepath = DIR_DATA + gene_id + '.csv'
            reframe_variants(generate_variants_df(gene_id)
                             ).to_csv(filepath, index=False)
            saved_list.append(filepath)
            # constraints
            constraints_list.append(fetch_constraints_by_gene_id(gene_id))
            print('\x1b[6;30;42m' + 'Saved: ' + gene_id + '\x1b[0m')
        except Exception as err:
            print(err)
            print('\x1b[6;30;41m' + 'Error: ' + gene_id + '\x1b[0m')


def merge_csv(gene_id_list):
    '''
    Download the merged csv file to current path, name as PATH_VARIANT_OUTPUT_FILE
    '''
    generate_csv_files(gene_id_list)
    # include headers
    combined_csv = pd.read_csv(saved_list[0])
    combined_csv.to_csv(PATH_VARIANT_OUTPUT_FILE,
                        encoding="utf_8_sig", index=False)

    for gene_id in saved_list[1:]:
        combined_csv = pd.read_csv(gene_id)
        combined_csv.to_csv(PATH_VARIANT_OUTPUT_FILE, encoding="utf_8_sig",
                            index=False, header=False, mode='a+')
    print("Merging downloaded data to %s" % PATH_VARIANT_OUTPUT_FILE)
    # add reframe_data and header
    new_c_df = pd.DataFrame(constraints_list, columns=HEADER_CONSTRAINTS)
    new_c_df.to_csv(PATH_CONSTRAINTS_OUTPUT_FILE,
                    encoding="utf_8_sig", index=False)
    print("Merging downloaded data to %s" % PATH_CONSTRAINTS_OUTPUT_FILE)



def initialize_dirs():
    '''
    Prepares the directories
    '''

    try:
        if not os.path.exists(DIR_DATA):
            os.mkdir(DIR_DATA)
        if not os.path.exists(DIR_OUTPUT):
            os.mkdir(DIR_OUTPUT)

        if os.path.exists(PATH_VARIANT_OUTPUT_FILE):
            os.remove(PATH_VARIANT_OUTPUT_FILE)

        if os.path.exists(PATH_CONSTRAINTS_OUTPUT_FILE):
            os.remove(PATH_CONSTRAINTS_OUTPUT_FILE)
    except OSError:
        pass
    else:
        print ("Successfully created the directory %s " % DIR_DATA)
        print ("Successfully created the directory %s " % DIR_OUTPUT)


if __name__ == '__main__':
    initialize_dirs()
    # Read interested genes
    df = pd.read_csv(FILE_GENE_LIST, delimiter=',')
    gene_id_list = df.columns.tolist()
    if len(gene_id_list) > 0:
        merge_csv(gene_id_list)
    else:
        print('Please list interested genes in interested_genes.csv file!')
