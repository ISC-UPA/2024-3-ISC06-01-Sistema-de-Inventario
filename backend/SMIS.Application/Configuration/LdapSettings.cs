﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SMIS.Application.Configuration
{
    public class LdapSettings
    {
        public string Server { get; set; }
        public string Domain { get; set; }
        public string User { get; set; }
        public string Password { get; set; }
        public string BaseDN { get; set; }
    }
}
