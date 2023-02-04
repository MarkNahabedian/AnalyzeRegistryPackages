# Script for making "standard" plots.

using AnalyzeRegistryPackages

svg_collected(:src, :readme)
svg_collected(:src, :docs, :readme)
svg_collected(:src, :docs)
svg_collected(:src, :tests)

threshold_satisfaction_plot("satisfies-test_min_fraction", "tests÷(tests+src)",
                            row -> row.tests / (row.tests + row.src))

threshold_satisfaction_plot("satisfies-doc_min_fraction", "docs÷(docs+src)",
                            row -> row.docs / (row.docs + row.src))

threshold_satisfaction_plot("satisfies-readme_min_fraction", "readme÷(readme+src)",
                            row -> row.readme / (row.readme + row.src))

