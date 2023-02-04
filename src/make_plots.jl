# Script for making "standard" plots.

using AnalyzeRegistryPackages

svg_collected(:src, :readme)
svg_collected(:src, :docs, :readme)
svg_collected(:src, :docs)
svg_collected(:src, :tests)

threshold_satisfaction_plot("satisfies-test_min_fraction",
                            row -> row.tests / (row.tests + row.src))

threshold_satisfaction_plot("satisfies-doc_min_fraction",
                            row -> row.docs / (row.docs + row.src))

threshold_satisfaction_plot("satisfies-readme_min_fraction",
                            row -> row.readme / (row.readme + row.src))

