//using SMIS.Core.Interfaces;
//using System.DirectoryServices.Protocols;

//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
//using System.Threading.Tasks;

//namespace SMIS.Application.Services
//{
//    public class LdapService : ILdapServer
//    {
//        private readonly string _ldapServer;
//        private readonly string _ldapDomain;
//        private readonly string _ldapUser;
//        private readonly string _ldapPassword;
//        private readonly string _ldapBaseDn;

//        public LdapService (string ldapServer, string ldapDomain, string ldapUser, string ldapPassword, string ldapBaseDn)
//        {
//            _ldapServer = ldapServer;
//            _ldapDomain = ldapDomain;
//            _ldapUser = ldapUser;
//            _ldapPassword = ldapPassword;
//            _ldapBaseDn = ldapBaseDn;
//        }

//        public void ConnectToLdap()
//        {
//            string ldapUserName = $"{_ldapDomain}\\{_ldapUser}";

//            using (var ldapConnection = new LdapConnection(_ldapServer))
//            {
//                ldapConnection.SessionOptions.ProtocolVersion = 3;
//                ldapConnection.AuthType = AuthType.Basic;

//                var networkCredential = new System.Net.NetworkCredential(ldapUserName, _ldapPassword);
//                ldapConnection.Bind(networkCredential);

//                Console.WriteLine("Conectado exitosamente al servidor LDAP.");
//            }
//        }
//    }
//}
