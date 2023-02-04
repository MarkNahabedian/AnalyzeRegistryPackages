# Script for making "standard" plots.

using AnalyzeRegistryPackages

svg_collected(:src, :readme)
svg_collected(:src, :docs, :readme)
svg_collected(:src, :docs)
svg_collected(:src, :tests)

threshold_satisfaction_plot("tests÷(tests+src)",
                            row -> row.tests / (row.tests + row.src))

threshold_satisfaction_plot("docs÷(docs+src)",
                            row -> row.docs / (row.docs + row.src))

threshold_satisfaction_plot("readme÷(readme+src)",
                            row -> row.readme / (row.readme + row.src))

