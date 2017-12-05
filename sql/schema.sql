--
-- Table structure for table `erro_admin`
--

CREATE TABLE IF NOT EXISTS `erro_admin` (
  `id` int(11) NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `rank` varchar(32) NOT NULL DEFAULT 'Administrator',
  `flags` int(16) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `erro_ban`
--

CREATE TABLE IF NOT EXISTS `erro_ban` (
  `id` int(11) NOT NULL,
  `bantime` datetime NOT NULL,
  `serverip` varchar(32) NOT NULL,
  `bantype` varchar(32) NOT NULL,
  `reason` text NOT NULL,
  `job` varchar(32) DEFAULT NULL,
  `duration` int(11) NOT NULL,
  `rounds` int(11) DEFAULT NULL,
  `expiration_time` datetime NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `computerid` varchar(32) NOT NULL DEFAULT '',
  `ip` varchar(32) NOT NULL DEFAULT '',
  `a_ckey` varchar(32) NOT NULL,
  `a_computerid` varchar(32) NOT NULL DEFAULT '',
  `a_ip` varchar(32) NOT NULL DEFAULT '',
  `who` text NOT NULL,
  `adminwho` text NOT NULL,
  `edits` text,
  `unbanned` tinyint(1) DEFAULT NULL,
  `unbanned_datetime` datetime DEFAULT NULL,
  `unbanned_ckey` varchar(32) DEFAULT NULL,
  `unbanned_computerid` varchar(32) DEFAULT NULL,
  `unbanned_ip` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `erro_player`
--

CREATE TABLE IF NOT EXISTS `erro_player` (
  `id` int(11) NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `firstseen` datetime NOT NULL,
  `lastseen` datetime NOT NULL,
  `ip` varchar(18) NOT NULL,
  `computerid` varchar(32) NOT NULL,
  `lastadminrank` varchar(32) NOT NULL DEFAULT 'Player'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `erro_watch`
--

CREATE TABLE IF NOT EXISTS `erro_watch` (
  `ckey` varchar(32) NOT NULL,
  `reason` text NOT NULL,
  `adminckey` varchar(32) NOT NULL,
  `timestamp` datetime NOT NULL,
  `last_editor` varchar(32) NOT NULL,
  `edits`  text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `library`
--

CREATE TABLE IF NOT EXISTS `library` (
  `id` int(11) NOT NULL,
  `author` text NOT NULL,
  `title` text NOT NULL,
  `content` text NOT NULL,
  `category` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `whitelist`
--

CREATE TABLE IF NOT EXISTS `whitelist` (
  `id` int(11) NOT NULL,
  `ckey` text NOT NULL,
  `race` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `erro_admin`
--
ALTER TABLE `erro_admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erro_ban`
--
ALTER TABLE `erro_ban`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erro_player`
--
ALTER TABLE `erro_player`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ckey` (`ckey`);

--
-- Indexes for table `erro_watch`
--
ALTER TABLE `erro_watch`
  ADD PRIMARY KEY (`ckey`);

--
-- Indexes for table `library`
--
ALTER TABLE `library`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `whitelist`
--
ALTER TABLE `whitelist`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `erro_admin`
--
ALTER TABLE `erro_admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erro_ban`
--
ALTER TABLE `erro_ban`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erro_player`
--
ALTER TABLE `erro_player`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `library`
--
ALTER TABLE `library`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `whitelist`
--
ALTER TABLE `whitelist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
