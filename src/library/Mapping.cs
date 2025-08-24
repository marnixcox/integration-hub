using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace Integration.Library
{
    public static class Mapping
    {
        // Checks if input string is Base64 encoded. 
        private static bool IsBase64(this string base64String)
        {
            if (base64String == null || base64String.Length == 0 || base64String.Length % 4 != 0
               || base64String.Contains(' ') || base64String.Contains('\t') || base64String.Contains('\r') || base64String.Contains("\n"))
                return false;
            try
            {
                Convert.FromBase64String(base64String);
                return true;
            }
            catch (Exception exception)
            {
                Trace.TraceError(exception.Message);
            }
            return false;
        }
    }
}