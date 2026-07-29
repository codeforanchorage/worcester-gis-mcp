lambda_name = "worcester-gis-mcp-prod"
stage_name  = "prod"
aws_region  = "us-west-2"
config_file = "config.yaml"
# 1024 MB: aggregate_by_polygon holds up to AGG_SOURCE_LIMIT source features in
# memory plus a bounded 32-entry polygon cache. Also buys more Lambda
# CPU, which accelerates the pure-Python point-in-polygon work.
lambda_memory   = 1024
lambda_timeout  = 120
api_quota_limit = 3000
api_rate_limit  = 5
api_burst_limit = 10
custom_domain   = "worcester-gis.codeforanchorage.org"

# Cap concurrent Lambda executions. Cost and blast-radius protection if
# WAF is bypassed via distributed sources. Conversational MCP traffic does
# not need horizontal scale; raise if legitimate users start getting throttled.
lambda_reserved_concurrency = 10

# WAF per-IP rate limit (rolling 5-minute window). The MCP tools are
# conversational, so 1 rps sustained per IP (~300/5min) is plenty for
# real users and tight enough to slow scrapers and denial-of-wallet probes.
#
# NOTE: with use_shared_waf = true this value is no longer read. The effective
# limit is the `worcester` entry in mcp-stats' `fleet_waf_members`; change it
# there. Kept here so rolling back (use_shared_waf = false) restores the same
# limit this MCP has always had.
waf_rate_limit_per_5min = 300

# Use the fleet-wide WAF instead of a dedicated ACL for this MCP. A dedicated
# ACL is ~$8/mo of fixed AWS charges regardless of traffic; the shared ACL keeps
# this MCP's 300/5min limit as its own counter, aggregated on (IP, Host).
# See mcp-stats/docs/waf-consolidation.md.
use_shared_waf = true
